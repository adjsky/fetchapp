package auth

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"regexp"
	"server/config"
	"server/pkg/handlers"
	"server/pkg/middlewares"
	"sync"

	"golang.org/x/crypto/bcrypt"

	"github.com/gorilla/mux"
)

var emailRegex *regexp.Regexp

func init() {
	emailRegex = regexp.MustCompile(`^\S+@\S+$`)
}

type restoreSession struct {
	email string
}

type service struct {
	config          *config.Config
	database        *sql.DB
	restoreSessions map[string]restoreSession
	restoreMutex    sync.RWMutex
}

// NewService creates a new auth service
func NewService(cfg *config.Config, db *sql.DB) *service {
	s := service{
		config:          cfg,
		database:        db,
		restoreSessions: make(map[string]restoreSession),
	}
	return &s
}

// Register auth service
func (serv *service) Register(r *mux.Router) {
	appJsonMiddleware := middlewares.ContentTypeValidator("application/json")
	r.Handle("/login", appJsonMiddleware(http.HandlerFunc(serv.handleLogin))).Methods("POST")
	r.Handle("/signup", appJsonMiddleware(http.HandlerFunc(serv.handleSignup))).Methods("POST")
	r.Handle("/restore", appJsonMiddleware(http.HandlerFunc(serv.handleRestore))).Methods("PUT")
	r.Handle("/valid", appJsonMiddleware(http.HandlerFunc(serv.handleValid))).Methods("POST")
}


func (serv *service) handleLogin(w http.ResponseWriter, req *http.Request) {
	data, _ := io.ReadAll(req.Body)
	var reqStruct loginRequest
	err := json.Unmarshal(data, &reqStruct)
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	if reqStruct.Email == "" || reqStruct.Password == "" {
		handlers.RespondError(w, http.StatusBadRequest, "no password or email provided")
		return
	}
	var password string
	row := serv.Database.QueryRow("SELECT password FROM Users WHERE email = ?", reqStruct.Email)
	err = row.Scan(&password)
	if err != nil {
		handlers.RespondError(w, http.StatusUnauthorized, "no user registered with this email")
		return
	}
	if bcrypt.CompareHashAndPassword([]byte(password), []byte(reqStruct.Password)) != nil {
		handlers.RespondError(w, http.StatusUnauthorized, "wrong email/password pair")
		return
	}
	claims := GenerateClaims(reqStruct.Email)
	token, _ := GenerateTokenString(claims, serv.SecretKey)
	res := loginResponse{
		Code:  http.StatusOK,
		Token: token,
	}
	handlers.Respond(w, &res, res.Code)
}

func (serv *service) handleSignup(w http.ResponseWriter, req *http.Request) {
	data, _ := io.ReadAll(req.Body)
	var reqStruct signupRequest
	err := json.Unmarshal(data, &reqStruct)
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	if reqStruct.Email == "" || reqStruct.Password == "" {
		handlers.RespondError(w, http.StatusBadRequest, "no password or email provided")
		return
	}
	matched := emailRegex.Match([]byte(reqStruct.Email))
	if !matched {
		handlers.RespondError(w, http.StatusBadRequest, "invalid email address")
		return
	}
	hashPassword, err := bcrypt.GenerateFromPassword([]byte(reqStruct.Password), bcrypt.DefaultCost)
	if err != nil {
		fmt.Println("hash generating error in signup: ", err)
	}
	_, err = serv.Database.Exec("INSERT INTO Users (email, password) VALUES (?, ?)", reqStruct.Email, hashPassword)
	if err != nil {
		handlers.RespondError(w, http.StatusConflict, "this email is registered")
		return
	}
	claims := GenerateClaims(reqStruct.Email)
	token, err := GenerateTokenString(claims, serv.SecretKey)
	if err != nil {
		log.Println(err)
	}
	res := signupResponse{
		Code:  http.StatusOK,
		Token: token,
	}
	handlers.Respond(w, &res, res.Code)
}

func (serv *service) handleRestore(w http.ResponseWriter, req *http.Request) {
	if CheckAuthorized(req) {
		serv.handleRestoreAuth(w, req)
	} else {
		handlers.RespondError(w, http.StatusUnauthorized, "not authorized person can't change password")
	}
}

func (serv *service) handleRestoreAuth(w http.ResponseWriter, req *http.Request) {
	data, _ := io.ReadAll(req.Body)
	var reqStruct restoreRequest
	err := json.Unmarshal(data, &reqStruct)
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	if reqStruct.OldPassword == "" || reqStruct.NewPassword == "" {
		handlers.RespondError(w, http.StatusBadRequest, "no old or new password provided")
		return
	}
	userClaims, err := GetClaims(GetToken(req), serv.SecretKey)
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "invalid auth token provided")
		return
	}
	var userID int
	var userPassword string
	row := serv.Database.QueryRow("SELECT ID, password FROM Users WHERE email = ?", userClaims.Email)
	row.Scan(&userID, &userPassword)
	if bcrypt.CompareHashAndPassword([]byte(userPassword), []byte(reqStruct.OldPassword)) != nil {
		handlers.RespondError(w, http.StatusUnauthorized, "old password doesn't correspond to account password")
		return
	}
	hashPassword, err := bcrypt.GenerateFromPassword([]byte(reqStruct.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		fmt.Println("hash generating error in restore: ", err)
	}
	serv.Database.Exec("UPDATE Users SET password = ? WHERE ID = ?", hashPassword, userID)
	handlers.Respond(w, restoreResponse{Code: http.StatusOK}, http.StatusOK)
}

		go func() {
			_ = helpers.SendEmail(&serv.config.Smtp,
				[]string{reqData.Email},
				[]byte("Subject: Restore account\n"+token))

func (serv *service) handleValid(w http.ResponseWriter, req *http.Request) {
	data, _ := io.ReadAll(req.Body)
	var reqStruct validRequest
	err := json.Unmarshal(data, &reqStruct)
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	if reqStruct.Token == "" {
		handlers.RespondError(w, http.StatusBadRequest, "no token provided")
		return
	}
	_, err = GetClaims(reqStruct.Token, serv.SecretKey)
	res := validResponse{
		Code:  http.StatusOK,
		Valid: err == nil,
	}
	handlers.Respond(w, &res, res.Code)
}
