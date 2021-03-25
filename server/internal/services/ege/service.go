package ege

import (
	"io"
	"mime/multipart"
	"net/http"
	"os"
	"path/filepath"
	"server/pkg/handlers"
	"server/pkg/middlewares"
	"strconv"
	"strings"

	"github.com/gorilla/mux"
)

// Service provides functionality to solve EGE problems
type Service struct {
	TempDir string
}

// Register service in a provided router
func (serv *Service) Register(r *mux.Router) {
	multipartMiddleware := middlewares.ContentTypeValidator("multipart/related")
	r.Handle("/{number:[0-9]+}", multipartMiddleware(http.HandlerFunc(serv.handleQuestion))).Methods("POST")
	r.HandleFunc("/available", serv.handleAvailable).Methods("GET")
}

func (serv *Service) handleQuestion(w http.ResponseWriter, req *http.Request) {
	mReader := multipart.NewReader(req.Body, req.Context().Value(middlewares.BoundaryID).(string))
	metadataPart, err := mReader.NextPart()
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "no metadata part provided")
		return
	}
	var questionReq question24Request
	parseBodyPartToJson(metadataPart, &questionReq)
	if err != nil || questionReq.Type == 0 {
		handlers.RespondError(w, http.StatusBadRequest, "wrong metadata body")
		return
	}
	textPart, err := mReader.NextPart()
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "no text part provided")
		return
	}
	text, err := io.ReadAll(textPart)
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, err.Error())
		return
	}
	filename := saveToFile(serv.TempDir, text)
	filepath := filepath.Join(serv.TempDir, filename)
	defer os.Remove(filepath)
	questionNumber, _ := strconv.Atoi(mux.Vars(req)["number"]) // can ignore error since router validates that path is a number
	result, err := processQuestion(questionNumber, filepath, &questionReq)
	result = strings.TrimSuffix(result, "\n") // since python prints everything with endline character we need to trim it
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, result)
		return
	}
	resultInt, _ := strconv.Atoi(result)
	res := question24Response{
		Code:   http.StatusOK,
		Result: resultInt,
	}
	handlers.Respond(w, &res, res.Code)
}

func (serv *Service) handleAvailable(w http.ResponseWriter, req *http.Request) {
	result, err := executeScript(pythonScriptPath, "available")
	result = strings.TrimSuffix(result, "\n") // since python prints everything with endline character we need to trim it
	if err != nil {
		handlers.RespondError(w, http.StatusInternalServerError, result)
		return
	}
	res := availabeResponse{
		Code:               http.StatusOK,
		QuestionsAvailable: result,
	}
	handlers.Respond(w, &res, res.Code)
}
