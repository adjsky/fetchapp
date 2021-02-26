package handler

import (
	"context"
	"gotest/internal/auth"
	"log"
	"net/http"
	"strings"
)

// ContextKey is type that used to reference data in context assosiated with
type ContextKey int

const (
	// ClaimsID constant used to reference claims in request context
	ClaimsID ContextKey = iota + 1
)

// AuthMiddleware checks whether user has JWT token included or not
func AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		authHeader := req.Header.Get("Authorization")
		authData := strings.Split(authHeader, " ")
		if len(authData) == 0 {
			res := ErrorResponce{
				Code:    http.StatusUnauthorized,
				Message: "no authorization header provided",
			}
			Respond(w, &res, res.Code)
			return
		}
		if authData[0] != "Bearer" {
			res := ErrorResponce{
				Code:    http.StatusUnauthorized,
				Message: "wrong authorization method",
			}
			Respond(w, &res, res.Code)
			return
		}
		claims, err := auth.GetClaims(authData[1])
		if err != nil {
			res := ErrorResponce{
				Code:    http.StatusUnauthorized,
				Message: err.Error(),
			}
			Respond(w, &res, res.Code)
			return
		}

		req = req.WithContext(context.WithValue(req.Context(), ClaimsID, claims))

		next.ServeHTTP(w, req)
	})
}

// LogMiddleware logs every incoming call to the server
func LogMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		log.Println(req.URL.Path, req.Method, req.UserAgent(), req.RemoteAddr)
		next.ServeHTTP(w, req)
	})
}
