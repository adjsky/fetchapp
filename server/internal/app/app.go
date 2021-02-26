package app

import (
	"gotest/config"
	"gotest/internal/handler"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

// Start server
func Start() {
	cfg := config.Get()
	r := mux.NewRouter()
	{
		r.Use(handler.LogMiddleware)
		r.NotFoundHandler = http.HandlerFunc(handler.NotFound)
		r.HandleFunc("/login", handler.LoginPage).Methods("POST")
	}

	apiRoute := r.PathPrefix("/api").Subrouter()
	{
		apiRoute.Use(handler.AuthMiddleware)
	}

	log.Println("Starting server on port: " + cfg.Port)
	log.Fatal(http.ListenAndServe(cfg.Realm+":"+cfg.Port, r))
	//log.Fatal(http.ListenAndServeTLS(cfg.Realm+":"+cfg.Port, cfg.CertFile, cfg.KeyFile, r))
}
