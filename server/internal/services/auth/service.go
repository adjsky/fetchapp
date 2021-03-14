package auth

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"gotest/pkg/handlers"
	"io"
	"log"
	"net/http"
	"regexp"
	"sync"

	"golang.org/x/crypto/bcrypt"

	"github.com/gorilla/mux"
)

var emailRegex *regexp.Regexp

func init() {
	emailRegex = regexp.MustCompile(`^\S+@\S+$`)
}

// Service implements auth service
type Service struct {
	SecretKey       []byte
	Database        *sql.DB
	restoreSessions map[string]string
	restoreMutex    sync.RWMutex
}

// Register auth service
func (serv *Service) Register(r *mux.Router) {
	r.HandleFunc("/login", serv.loginHandler).Methods("POST")
	r.HandleFunc("/signup", serv.signupHandler).Methods("POST")
	r.HandleFunc("/restore", serv.restoreHandler).Methods("POST")
}

func (serv *Service) loginHandler(w http.ResponseWriter, req *http.Request) {
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

func (serv *Service) signupHandler(w http.ResponseWriter, req *http.Request) {
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
		handlers.RespondError(w, http.StatusBadRequest, "wrong email address")
		return
	}
	hashPassword, err := bcrypt.GenerateFromPassword([]byte(reqStruct.Password), bcrypt.DefaultCost)
	if err != nil {
		fmt.Println("hash generating error in signup: ", err)
	}
	_, err = serv.Database.Exec("INSERT INTO Users (email, password) VALUES (?, ?)", reqStruct.Email, hashPassword)
	if err != nil {
		handlers.RespondError(w, http.StatusConflict, err.Error())
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

func (serv *Service) restoreHandler(w http.ResponseWriter, req *http.Request) {
	data, _ := io.ReadAll(req.Body)
	var reqStruct restoreRequest
	err := json.Unmarshal(data, &reqStruct)
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "invalid request body")
		return
	}
	if reqStruct.Email == "" || reqStruct.NewPassword == "" {
		handlers.RespondError(w, http.StatusBadRequest, "no email or new password provided")
		return
	}
	row := serv.Database.QueryRow("SELECT ID FROM Users WHERE email = ?", reqStruct.Email)
	var id int
	err = row.Scan(&id)
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "no user created with this email")
		return
	}
	hashPassword, err := bcrypt.GenerateFromPassword([]byte(reqStruct.NewPassword), bcrypt.DefaultCost)
	if err != nil {
		fmt.Println("hash generating error in signup: ", err)
	}
	serv.Database.Exec("UPDATE Users SET password = ? WHERE ID = ?", hashPassword, id)

	handlers.Respond(w, restoreResponse{
		Code: http.StatusOK,
	}, http.StatusOK)
}
