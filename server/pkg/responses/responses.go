package responses

// Error is returned when an error is occured
type Error struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}
