package handler

// ErrorResponce is returned when error occured
type ErrorResponce struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}

// LoginResponce is returned when success login action is performed
type LoginResponce struct {
	Code  int    `json:"code"`
	Token string `json:"token"`
}
