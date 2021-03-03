package auth

import (
	"gotest/config"
	"testing"
	"time"

	"github.com/dgrijalva/jwt-go"
)

func TestGenerateTokenString(t *testing.T) {
	cfg := config.Get()
	t.Run("Generate token does not return error", func(t *testing.T) {
		claims := UserClaims{
			"John",
			jwt.StandardClaims{
				ExpiresAt: time.Now().Add(time.Hour * 24).Unix(),
			},
		}
		_, err := GenerateTokenString(&claims, cfg.SecretKey)
		if err != nil {
			t.Error("GenerateTokenString returned error:", err)
		}
	})
}

func TestGetClaims(t *testing.T) {
	cfg := config.Get()
	t.Run("Invalid token passed to GetClaims returns error and nil claims", func(t *testing.T) {
		claims, err := GetClaims("invalid token", cfg.SecretKey)
		if err == nil && claims != nil {
			t.Error("GetClaims returned non-nil claims and nil error")
		}
	})
	t.Run("Token generated from GenerateTokenString returns valid claims", func(t *testing.T) {
		passedClaims := UserClaims{
			"John",
			jwt.StandardClaims{
				ExpiresAt: time.Now().Add(time.Hour * 24).Unix(),
			},
		}
		tokenString, err := GenerateTokenString(&passedClaims, cfg.SecretKey)
		if err != nil {
			t.Error("GenerateTokenString returned error:", err)
			return
		}
		receivedClaims, err := GetClaims(tokenString, cfg.SecretKey)
		if err != nil {
			t.Error("GetClaims returned error:", err)
			return
		}
		if receivedClaims.Email != passedClaims.Email {
			t.Errorf("got: %s, expected: %s", receivedClaims.Email, passedClaims.Email)
		}
	})

	t.Run("outdated token can't pass validation", func(t *testing.T) {
		outdatedClaims := UserClaims{
			Email: "test@gmail.com",
			StandardClaims: jwt.StandardClaims{
				IssuedAt:  time.Now().Unix(),
				Issuer:    "adjsky",
				ExpiresAt: time.Now().Unix() - time.Hour.Milliseconds(),
			},
		}
		token, _ := GenerateTokenString(&outdatedClaims, cfg.SecretKey)
		claims, err := GetClaims(token, cfg.SecretKey)
		if claims != nil && err == nil {
			t.Error("outdated token should be not valid, but actually is valid")
		}
	})
}
