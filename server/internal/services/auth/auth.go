package auth

import (
	"time"

	"github.com/dgrijalva/jwt-go"
)

// UserClaims holds user information passed by Authorization http header
type UserClaims struct {
	Email string
	jwt.StandardClaims
}

// GenerateClaims generates new JWT token claims
func GenerateClaims(email string) *UserClaims {
	return &UserClaims{
		Email: email,
		StandardClaims: jwt.StandardClaims{
			IssuedAt:  time.Now().Unix(),
			Issuer:    "adjsky",
			Subject:   "auth",
			ExpiresAt: time.Now().Add(time.Hour * 24).Unix(),
		},
	}
}

// GenerateTokenString returns JWT string that is passed to client
func GenerateTokenString(claims *UserClaims, secretKey []byte) (string, error) {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	ss, err := token.SignedString(secretKey)
	return ss, err
}

// GetClaims decodes JWT string passed by client and returns data associated with it
func GetClaims(tokenString string, secretKey []byte) (*UserClaims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &UserClaims{}, func(token *jwt.Token) (interface{}, error) {
		return secretKey, nil
	})
	if err != nil {
		return nil, err
	}
	if claims, ok := token.Claims.(*UserClaims); ok {
		return claims, nil
	}
	return nil, nil
}
