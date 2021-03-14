package auth

type loginResponse struct {
	Code  int    `json:"code"`
	Token string `json:"token"`
}

type signupResponse struct {
	Code  int    `json:"code"`
	Token string `json:"token"`
}

type restoreResponse struct {
	Code int `json:"code"`
}
