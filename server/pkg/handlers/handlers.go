package handlers

import (
	"encoding/json"
	"gotest/pkg/responces"
	"net/http"
)

// Respond writes json data to caller
func Respond(w http.ResponseWriter, res interface{}, statusCode int) {
	w.Header().Set("Content-type", "application/json")
	w.WriteHeader(statusCode)
	json.NewEncoder(w).Encode(res)
}

// NotFound called when client tries to access wrong resource
func NotFound(w http.ResponseWriter, req *http.Request) {
	res := responces.Error{
		Code:    http.StatusNotFound,
		Message: "no resource found",
	}
	Respond(w, &res, res.Code)
}
