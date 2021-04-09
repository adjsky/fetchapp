package application

import (
	"database/sql"
	"log"
	"net/http"
	"os"
	"server/config"
	"server/internal/services/auth"
	"server/internal/services/ege"
	"server/pkg/handlers"
	"server/pkg/middlewares"

	"github.com/dchest/uniuri"
	"github.com/gorilla/mux"

	// initialize driver
	_ "github.com/mattn/go-sqlite3"
)

const migrationSceheme string = "CREATE TABLE IF NOT EXISTS 'Users' (" +
	"'email'	TEXT NOT NULL UNIQUE," +
	"'password'	TEXT NOT NULL," +
	"'ID'		INTEGER PRIMARY KEY);"

type app struct {
	Config   *config.Config
	Database *sql.DB
	Router   *mux.Router
	TempDir  string
}

// New creates the application instance
func New() *app {
	cfg := config.Get()
	db, err := sql.Open("sqlite3", "../database.db")
	if err != nil {
		log.Fatal(err)
	}
	migrateTable(db)
	tempDir, err := os.MkdirTemp("", uniuri.New())
	if err != nil {
		log.Fatal(err)
	}
	return &app{
		Config:   cfg,
		Database: db,
		Router:   mux.NewRouter(),
		TempDir:  tempDir,
	}
}

// Close does cleaning operations on the application
func (app *app) Close() {
	_ = app.Database.Close()
	_ = os.RemoveAll(app.TempDir)
}

func (app *app) initializeServices() {
	app.Router.Use(middlewares.Log)
	app.Router.NotFoundHandler = http.HandlerFunc(handlers.NotFound)

	authRouter := app.Router.PathPrefix("/auth").Subrouter()
	authService := auth.Service{
		SecretKey: app.Config.SecretKey,
		Database:  app.Database,
	}
	authService.Register(authRouter)

	apiRouter := app.Router.PathPrefix("/api").Subrouter()
	apiRouter.Use(authService.AuthMiddleware)

	egeRouter := apiRouter.PathPrefix("/ege").Subrouter()
	egeService := ege.NewService(app.TempDir)
	egeService.Register(egeRouter)
}

func migrateTable(db *sql.DB) {
	_, err := db.Exec(migrationSceheme)
	if err != nil {
		log.Fatal("failed to migrate the database scheme")
	}
}

// Start the server
func (app *app) Start() {
	app.initializeServices()
	log.Println("Starting server on port: " + app.Config.Port)
	log.Fatal(http.ListenAndServe(app.Config.Realm+":"+app.Config.Port, app.Router))
	//log.Fatal(http.ListenAndServeTLS(cfg.Realm+":"+cfg.Port, cfg.CertFile, cfg.KeyFile, r))
}
