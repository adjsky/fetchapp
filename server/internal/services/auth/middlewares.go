package auth

import (
	"context"
	"gotest/pkg/handlers"
	"gotest/pkg/responces"
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
func (service *Service) AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		authHeader := req.Header.Get("Authorization")
		authData := strings.Split(authHeader, " ")
		if len(authData) == 0 {
			res := responces.Error{
				Code:    http.StatusUnauthorized,
				Message: "no authorization header provided",
			}
			handlers.Respond(w, &res, res.Code)
			return
		}
		if authData[0] != "Bearer" {
			res := responces.Error{
				Code:    http.StatusUnauthorized,
				Message: "wrong authorization method",
			}
			handlers.Respond(w, &res, res.Code)
			return
		}
		claims, err := GetClaims(authData[1], service.SecretKey)
		if err != nil {
			res := responces.Error{
				Code:    http.StatusUnauthorized,
				Message: err.Error(),
			}
			handlers.Respond(w, &res, res.Code)
			return
		}

		req = req.WithContext(context.WithValue(req.Context(), ClaimsID, claims))

		next.ServeHTTP(w, req)
	})
}
