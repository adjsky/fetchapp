package auth

import (
	"gotest/config"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestAuthMiddleware(t *testing.T) {
	authService := Service{
		SecretKey: config.Get().SecretKey,
	}
	req, err := http.NewRequest("POST", "/random", nil)
	if err != nil {
		t.Error(err.Error())
	}
	handler := authService.AuthMiddleware(http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		w.WriteHeader(http.StatusOK)
	}))
	t.Run("Request with null authorization header returns 401 status code", func(t *testing.T) {
		writer := httptest.NewRecorder()
		handler.ServeHTTP(writer, req)
		if writer.Code != http.StatusUnauthorized {
			t.Errorf("expected status code: %v, got: %v", http.StatusUnauthorized, writer.Code)
		}
	})
	t.Run("Request with wrong authorization header returns 401 status code", func(t *testing.T) {
		writer := httptest.NewRecorder()
		req.Header.Set("Authorization", "Basic")
		handler.ServeHTTP(writer, req)
		if writer.Code != http.StatusUnauthorized {
			t.Errorf("expected status code: %v, got: %v", http.StatusUnauthorized, writer.Code)
		}
	})
	t.Run("Request with invalid token return 401 status code", func(t *testing.T) {
		writer := httptest.NewRecorder()
		req.Header.Set("Authorization", "Bearer "+"asd")
		handler.ServeHTTP(writer, req)
		if writer.Code != http.StatusUnauthorized {
			t.Errorf("expected status code: %v, got: %v", http.StatusUnauthorized, writer.Code)
		}
	})
	t.Run("Middleware should pass request with valid token", func(t *testing.T) {
		writer := httptest.NewRecorder()
		claims := GenerateClaims("loh@mail.ru")
		token, _ := GenerateTokenString(claims, authService.SecretKey)
		req.Header.Set("Authorization", "Bearer "+token)
		handler.ServeHTTP(writer, req)
		if writer.Code != http.StatusOK {
			t.Errorf("expected status code: %v, got: %v", http.StatusOK, writer.Code)
		}
	})
}
