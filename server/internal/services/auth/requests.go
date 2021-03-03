package auth

type loginRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type signupRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type restoreRequest struct {
	Email       string `json:"email"`
	NewPassword string `json:"new_password"`
}
