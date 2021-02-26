package handler

// LoginRequest is used to get data received from user in /login endpoint
type LoginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}
