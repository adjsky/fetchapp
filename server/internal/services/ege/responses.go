package ege

type question24Response struct {
	Code   int `json:"code"`
	Result int `json:"result"`
}

type availabeResponse struct {
	Code               int    `json:"code"`
	QuestionsAvailable string `json:"questions_available"`
}
