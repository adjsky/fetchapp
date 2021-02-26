package auth

import (
	"testing"
	"time"

	"github.com/dgrijalva/jwt-go"
)

func TestGenerateTokenString(t *testing.T) {
	t.Run("Generate token does not return error", func(t *testing.T) {
		claims := MyCustomClaims{
			"John",
			jwt.StandardClaims{
				ExpiresAt: time.Now().Add(time.Hour * 24).Unix(),
			},
		}
		_, err := GenerateTokenString(&claims)
		if err != nil {
			t.Error("GenerateTokenString returned error:", err)
		}
	})
}

func TestGetClaims(t *testing.T) {
	t.Run("Invalid token passed GetClaims returns error and nil claims", func(t *testing.T) {
		claims, err := GetClaims("invalid token")
		if err == nil && claims != nil {
			t.Error("GetClaims returned non-nil claims and nil error")
		}
	})
	t.Run("Token generated from GenerateTokenString returns valid claims", func(t *testing.T) {
		passedClaims := MyCustomClaims{
			"John",
			jwt.StandardClaims{
				ExpiresAt: time.Now().Add(time.Hour * 24).Unix(),
			},
		}
		tokenString, err := GenerateTokenString(&passedClaims)
		if err != nil {
			t.Error("GenerateTokenString returned error:", err)
			return
		}
		receivedClaims, err := GetClaims(tokenString)
		if err != nil {
			t.Error("GetClaims returned error:", err)
			return
		}
		if receivedClaims.Name != passedClaims.Name {
			t.Errorf("got: %s, expected: %s", receivedClaims.Name, passedClaims.Name)
		}
	})
}
