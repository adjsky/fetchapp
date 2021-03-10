package auth

import (
	"database/sql"
	"encoding/json"
	"gotest/pkg/handlers"
	"gotest/pkg/responces"
	"io"
	"log"
	"net/http"
	"regexp"
	"sync"

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
		res := responces.Error{
			Code:    http.StatusBadRequest,
			Message: err.Error(),
		}
		handlers.Respond(w, &res, res.Code)
		return
	}
	if reqStruct.Email == "" || reqStruct.Password == "" {
		res := responces.Error{
			Code:    http.StatusBadRequest,
			Message: "no password or email provided",
		}
		handlers.Respond(w, &res, res.Code)
		return
	}

	var password string
	row := serv.Database.QueryRow("SELECT password FROM Users WHERE email = ?", reqStruct.Email)
	err = row.Scan(&password)
	if err != nil {
		res := responces.Error{
			Code:    http.StatusUnauthorized,
			Message: "no user registered with this email",
		}
		handlers.Respond(w, &res, res.Code)
		return
	}
	if password != reqStruct.Password {
		res := responces.Error{
			Code:    http.StatusUnauthorized,
			Message: "wrong email/password pair",
		}
		handlers.Respond(w, &res, res.Code)
		return
	}

	claims := GenerateClaims(reqStruct.Email)
	token, err := GenerateTokenString(claims, serv.SecretKey)
	if err != nil {
		log.Println(err)
	}
	res := loginResponce{
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
		res := responces.Error{
			Code:    http.StatusBadRequest,
			Message: err.Error(),
		}
		handlers.Respond(w, &res, res.Code)
		return
	}
	if reqStruct.Email == "" || reqStruct.Password == "" {
		res := responces.Error{
			Code:    http.StatusBadRequest,
			Message: "no password or email provided",
		}
		handlers.Respond(w, &res, res.Code)
		return
	}

	matched := emailRegex.Match([]byte(reqStruct.Email))
	if !matched {
		res := responces.Error{
			Code:    http.StatusBadRequest,
			Message: "wrong email address",
		}
		handlers.Respond(w, &res, res.Code)
		return
	}

	_, err = serv.Database.Exec("INSERT INTO Users (email, password) VALUES (?, ?)", reqStruct.Email, reqStruct.Password)
	if err != nil {
		res := responces.Error{
			Code:    http.StatusConflict,
			Message: err.Error(),
		}
		handlers.Respond(w, &res, res.Code)
		return
	}

	claims := GenerateClaims(reqStruct.Email)
	token, err := GenerateTokenString(claims, serv.SecretKey)
	if err != nil {
		log.Println(err)
	}
	res := signupResponce{
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
		res := responces.Error{
			Code:    http.StatusBadRequest,
			Message: "wrong request body",
		}
		handlers.Respond(w, &res, res.Code)
		return
	}
	if reqStruct.Email == "" || reqStruct.NewPassword == "" {
		res := responces.Error{
			Code:    http.StatusBadRequest,
			Message: "no email or new password provided",
		}
		handlers.Respond(w, &res, res.Code)
		return
	}
	row := serv.Database.QueryRow("SELECT ID FROM Users WHERE email = ?", reqStruct.Email)
	var id int
	err = row.Scan(&id)
	if err != nil {
		res := responces.Error{
			Code:    http.StatusBadRequest,
			Message: "no user created with this email",
		}
		handlers.Respond(w, &res, res.Code)
		return
	}

	serv.Database.Exec("UPDATE Users SET password = ? WHERE ID = ?", reqStruct.NewPassword, id)

	handlers.Respond(w, restoreResponce{
		Code: http.StatusOK,
	}, http.StatusOK)
}
