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

func executeScript(questionNumber, type_ int, path string) (string, error) {
	var out strings.Builder
	var errOut strings.Builder
	command := exec.Command("python", "../internal/services/ege/python/main.py", "solve",
		strconv.Itoa(questionNumber), "-f", path, "-t", strconv.Itoa(type_))
	command.Stdout = &out
	command.Stderr = &errOut
	err := command.Run()
	if err != nil {
		return errOut.String(), err
	}
	return out.String(), nil
}
