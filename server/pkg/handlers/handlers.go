package handlers

import (
	"encoding/json"
	"gotest/pkg/responses"
	"net/http"
)

// Respond writes json data to a caller
func Respond(w http.ResponseWriter, res interface{}, statusCode int) {
	w.Header().Set("Content-type", "application/json")
	w.WriteHeader(statusCode)
	json.NewEncoder(w).Encode(res)
}

// RespondError responds with an error message to a client
func RespondError(w http.ResponseWriter, code int, message string) {
	res := responses.Error{
		Code:    code,
		Message: message,
	}
	Respond(w, &res, res.Code)
}

// NotFound is called when a client tries to access wrong resource
func NotFound(w http.ResponseWriter, req *http.Request) {
	res := responses.Error{
		Code:    http.StatusNotFound,
		Message: "no resource found",
	}
	Respond(w, &res, res.Code)
}
