package auth

import (
	"context"
	"gotest/pkg/handlers"
	"net/http"
	"strings"
)

// ContextKey is a type that is used to reference data in a context associated with
type ContextKey int

const (
	// ClaimsID constant is used to reference claims in a request context
	ClaimsID ContextKey = iota + 1
)

// AuthMiddleware checks whether user has JWT token included or not
func (service *Service) AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		authHeader := req.Header.Get("Authorization")
		authData := strings.Split(authHeader, " ")
		if len(authData) == 0 {
			handlers.RespondError(w, http.StatusUnauthorized, "no authorization header provided")
			return
		}
		if authData[0] != "Bearer" {
			handlers.RespondError(w, http.StatusUnauthorized, "wrong authorization method")
			return
		}
		claims, err := GetClaims(authData[1], service.SecretKey)
		if err != nil {
			handlers.RespondError(w, http.StatusUnauthorized, "invalid auth token")
			return
		}
		req = req.WithContext(context.WithValue(req.Context(), ClaimsID, claims))
		next.ServeHTTP(w, req)
	})
}
