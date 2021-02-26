package handler

import (
	"encoding/json"
	"io"
	"net/http"
)

// Respond writes json data to caller
func Respond(w http.ResponseWriter, res interface{}, statusCode int) {
	w.Header().Set("Content-type", "application/json")
	w.WriteHeader(statusCode)
	json.NewEncoder(w).Encode(res)
}

// NotFound is called when client tries to access wrong resource
func NotFound(w http.ResponseWriter, req *http.Request) {
	res := ErrorResponce{
		Code:    http.StatusNotFound,
		Message: "no resource found",
	}
	Respond(w, &res, res.Code)
}

// LoginPage handles user login process
func LoginPage(w http.ResponseWriter, req *http.Request) {
	//time.Sleep(time.Duration(time.Hour * 2))
	data, _ := io.ReadAll(req.Body)
	var loginRequest LoginRequest
	err := json.Unmarshal(data, &loginRequest)
	if err != nil {
		res := ErrorResponce{
			Code:    http.StatusBadRequest,
			Message: err.Error(),
		}
		Respond(w, &res, res.Code)
		return
	}
	if loginRequest.Email == "" || loginRequest.Password == "" {
		res := ErrorResponce{
			Code:    http.StatusBadRequest,
			Message: "no password or email provided",
		}
		Respond(w, &res, res.Code)
		return
	}
	res := LoginResponce{
		Code:  http.StatusOK,
		Token: "asd",
	}
	Respond(w, &res, res.Code)
}
