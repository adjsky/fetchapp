package responces

// Error is returned when error occured
type Error struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}
