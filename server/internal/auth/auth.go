package auth

import (
	"gotest/config"

	"github.com/dgrijalva/jwt-go"
)

// MyCustomClaims holds user information passed by Authorization http header
type MyCustomClaims struct {
	Name string
	jwt.StandardClaims
}

// GenerateTokenString return JWT  string that is passed to client
func GenerateTokenString(claims *MyCustomClaims) (string, error) {
	signKey := config.Get().SecretKey
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	ss, err := token.SignedString(signKey)
	return ss, err
}

// GetClaims decodes JWT string passed by client and returns data associated with it
func GetClaims(tokenString string) (*MyCustomClaims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &MyCustomClaims{}, func(token *jwt.Token) (interface{}, error) {
		return config.Get().SecretKey, nil
	})
	if err != nil {
		return nil, err
	}
	if claims, ok := token.Claims.(*MyCustomClaims); ok && token.Valid {
		return claims, nil
	}
	return nil, nil
}
