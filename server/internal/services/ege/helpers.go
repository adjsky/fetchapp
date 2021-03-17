package ege

import (
	"encoding/json"
	"io"
	"mime/multipart"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"
	"strings"

	"github.com/dchest/uniuri"
)

const pythonScriptPath string = "../internal/services/ege/python/main.py"

func parseBodyPartToJson(part *multipart.Part, v interface{}) error {
	metadataBody, err := io.ReadAll(part)
	if err != nil {
		return err
	}
	err = json.Unmarshal(metadataBody, v)
	if err != nil {
		return err
	}
	return nil
}

func saveToFile(path string, data []byte) (filename string) {
	filename = uniuri.NewLen(32)
	os.WriteFile(filepath.Join(path, filename), data, 0770)
	return
}

func executeScript(args ...string) (string, error) {
	var out strings.Builder
	var errOut strings.Builder
	command := exec.Command("python", args...)
	command.Stdout = &out
	command.Stderr = &errOut
	err := command.Run()
	if err != nil {
		return errOut.String(), err
	}
	return out.String(), nil
}

func processQuestion(questionNumber int, filepath string, req *question24Request) (string, error) {
	return executeScript(pythonScriptPath, "solve", strconv.Itoa(questionNumber), "-f",
		filepath, "-t", strconv.Itoa(req.Type), "-c", req.Char)
}
