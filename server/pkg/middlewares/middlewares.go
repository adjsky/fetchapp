package middlewares

import (
	"log"
	"net/http"
)

// Log middleware logs every incoming call to the server
func Log(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		log.Println(req.URL.Path, req.Method, req.UserAgent(), req.RemoteAddr)
		next.ServeHTTP(w, req)
	})
}
