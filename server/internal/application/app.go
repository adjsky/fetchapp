package application

import (
	"database/sql"
	"gotest/config"
	"gotest/internal/services/auth"
	"gotest/pkg/handlers"
	"gotest/pkg/middlewares"
	"log"
	"net/http"

	"github.com/gorilla/mux"

	// initialize driver
	_ "github.com/mattn/go-sqlite3"
)

// App struct is main entry to application
type App struct {
	Config   *config.Config
	Database *sql.DB
	Router   *mux.Router
}

// New creates app instance
func New() *App {
	cfg := config.Get()
	db, err := sql.Open("sqlite3", "database.db")
	if err != nil {
		log.Fatal(err)
	}
	return &App{
		Config:   cfg,
		Database: db,
		Router:   mux.NewRouter(),
	}
}

func (app *App) initializeServices() {
	app.Router.Use(middlewares.Log)
	app.Router.NotFoundHandler = http.HandlerFunc(handlers.NotFound)
	authService := auth.Service{
		SecretKey: app.Config.SecretKey,
		Database:  app.Database,
	}
	authService.Register(app.Router)

	apiRoute := app.Router.PathPrefix("/api").Subrouter()
	apiRoute.Use(authService.AuthMiddleware)
	apiRoute.HandleFunc("", test).Methods("GET")
}

func test(w http.ResponseWriter, req *http.Request) {

}

// Start server
func (app *App) Start() {
	app.initializeServices()
	log.Println("Starting server on port: " + app.Config.Port)
	log.Fatal(http.ListenAndServe(app.Config.Realm+":"+app.Config.Port, app.Router))
	//log.Fatal(http.ListenAndServeTLS(cfg.Realm+":"+cfg.Port, cfg.CertFile, cfg.KeyFile, r))
}
