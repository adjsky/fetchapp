package auth

import (
	"net/http"
	"strings"
)

// CheckAuthorized checks whether given request has a bearer token and returns it
func CheckAuthorized(req *http.Request) bool {
	authHeader := req.Header.Get("Authorization")
	authData := strings.Split(authHeader, " ")
	if len(authData) == 0 {
		return false
	}
	if authData[0] != "Bearer" || len(authData) != 2 {
		return false
	}
	return true
}

// GetToken returns a token from a request or an empty string if an user is not authorized or has an invalid authorization header
func GetToken(req *http.Request) string {
	if CheckAuthorized(req) {
		return strings.Split(req.Header.Get("Authorization"), " ")[1]
	}
	return ""
}
