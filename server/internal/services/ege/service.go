package ege

import (
	"gotest/pkg/handlers"
	"io"
	"mime"
	"mime/multipart"
	"net/http"
	"os"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/gorilla/mux"
)

// Service provides functionality to solve EGE problems
type Service struct {
	TempDir string
}

// Register service in provided router
func (serv *Service) Register(r *mux.Router) {
	r.HandleFunc("/{number:[0-9]+}", serv.handleMain)
}

func (serv *Service) handleMain(w http.ResponseWriter, req *http.Request) {
	contentType, params, err := mime.ParseMediaType(req.Header.Get("Content-Type"))
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "invalid content-type header")
		return
	}
	if contentType != "multipart/related" {
		handlers.RespondError(w, http.StatusBadRequest, "server accepts requests only with multipart/related content-type header")
		return
	}
	mReader := multipart.NewReader(req.Body, params["boundary"])
	metadataPart, err := mReader.NextPart()
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, "no metadata part was provided")
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
		handlers.RespondError(w, http.StatusBadRequest, "no text part was provided")
		return
	}
	text, err := io.ReadAll(textPart)
	if err != nil {
		handlers.RespondError(w, http.StatusBadRequest, err.Error())
		return
	}
	filename := saveToFile(serv.TempDir, text)
	path := filepath.Join(serv.TempDir, filename)
	questionNumber := mux.Vars(req)["number"]
	number, _ := strconv.Atoi(questionNumber)
	result, err := executeScript(number, questionReq.Type, path)
	result = strings.TrimSuffix(result, "\n")
	os.Remove(path)
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
