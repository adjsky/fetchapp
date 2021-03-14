package config

import (
	"os"
)

// Config holds data required to start an application
type Config struct {
	SecretKey []byte
	Realm     string
	Port      string
	CertFile  string
	KeyFile   string
}

// Get config instance filled with required data to start an application
func Get() *Config {
	certFile := os.Getenv("CERT_FILE")
	if certFile == "" {
		//log.Fatal("No certification file provided")
	}
	keyFile := os.Getenv("KEY_FILE")
	if keyFile == "" {
		//log.Fatal("No key file provided")
	}

	return &Config{
		SecretKey: []byte("SuperSecretKey"),
		Realm:     "localhost",
		Port:      "8080",
		CertFile:  certFile,
		KeyFile:   keyFile,
	}
}
