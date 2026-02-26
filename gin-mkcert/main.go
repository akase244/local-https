package main

import (
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.GET("/", func(c *gin.Context) {
		c.String(200, "Hello HTTPS Gin!")
	})

    r.HEAD("/", func(c *gin.Context) {
        c.Status(200)
    })

	log.Println("Listening on https://0.0.0.0:8443")
	if err := r.RunTLS(
		":8443",
		"/certs/snakeoil.crt",
		"/certs/snakeoil.key",
	); err != nil {
		log.Fatal(err)
	}
}
