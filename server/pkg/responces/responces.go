package responces

// Error is returned when an error was occured
type Error struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}
