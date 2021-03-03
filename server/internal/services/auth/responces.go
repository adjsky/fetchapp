package auth

type loginResponce struct {
	Code  int    `json:"code"`
	Token string `json:"token"`
}

type signupResponce struct {
	Code  int    `json:"code"`
	Token string `json:"token"`
}

type restoreResponce struct {
	Code int `json:"code"`
}
