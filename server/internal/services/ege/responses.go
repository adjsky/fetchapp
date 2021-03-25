package ege

type questionResponse struct {
	Code   int `json:"code"`
	Result int `json:"result"`
}

type availabeResponse struct {
	Code               int    `json:"code"`
	QuestionsAvailable string `json:"questions_available"`
}

type questionTypesResponse struct {
}
