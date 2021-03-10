package ege

import (
	"gotest/pkg/handlers"
	"gotest/pkg/responces"
	"net/http"

	"github.com/gorilla/mux"
)

// Service provides functionality to solve EGE problems
type Service struct {
}

// Register service in provided router
func (serv *Service) Register(r *mux.Router) {
	r.HandleFunc("", serv.handleMain)
}

func (serv *Service) handleMain(w http.ResponseWriter, req *http.Request) {
	response := responces.Error{
		Code:    http.StatusOK,
		Message: "test",
	}
	handlers.Respond(w, &response, response.Code)
}
