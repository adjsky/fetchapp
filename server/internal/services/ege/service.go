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

type service struct {
	tempDir string
}

// NewService creates a new EGE service
func NewService(tmpDir string) *service {
	return &service{
		tempDir: tmpDir,
	}
}

// Register service in a provided router
func (serv *service) Register(r *mux.Router) {
	multipartMiddleware := middlewares.ContentTypeValidator("multipart/related")
	r.HandleFunc("/{number:[0-9]+}/types", serv.handleQuestionTypes).Methods("GET")
	r.Handle("/{number:[0-9]+}", multipartMiddleware(http.HandlerFunc(serv.handleQuestion))).Methods("POST")
	r.HandleFunc("/available", serv.handleAvailable).Methods("GET")
}

func (serv *service) handleQuestion(w http.ResponseWriter, req *http.Request) {
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
	questionNumber, _ := strconv.Atoi(mux.Vars(req)["number"]) // can ignore an error since router validates that path is a number
	result, err := processQuestion(questionNumber, filepath, &questionReq)
	result = strings.TrimRight(result, "\r\n") // since python prints everything with an endline character we need to trim it
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, result)
		return
	}
	resultInt, _ := strconv.Atoi(result)
	res := questionResponse{
		Code:   http.StatusOK,
		Result: resultInt,
	}
	handlers.Respond(w, &res, res.Code)
}

func (serv *service) handleAvailable(w http.ResponseWriter, req *http.Request) {
	result, err := executeScript(pythonScriptPath, "available")
	result = strings.TrimRight(result, "\r\n") // since python prints everything with an endline character we need to trim it
	if err != nil {
		handlers.RespondError(w, http.StatusInternalServerError, result)
		return
	}
	res := availableResponse{
		Code:               http.StatusOK,
		QuestionsAvailable: result,
	}
	handlers.Respond(w, &res, res.Code)
}

func (serv *service) handleQuestionTypes(w http.ResponseWriter, req *http.Request) {
	questionNumber := mux.Vars(req)["number"]
	result, err := executeScript(pythonScriptPath, "types", questionNumber)
	result = strings.TrimRight(result, "\r\n") // since python prints everything with endline character we need to trim it
	if err != nil {
		handlers.RespondError(w, http.StatusInternalServerError, result)
		return
	}
	res := questionTypesResponse{
		Code:           http.StatusOK,
		TypesAvailable: result,
	}
	handlers.Respond(w, &res, res.Code)
}
