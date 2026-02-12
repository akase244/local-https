FROM golang:1.21-alpine AS builder

RUN go install github.com/jsha/minica@latest

FROM alpine:latest

COPY --from=builder /go/bin/minica /usr/local/bin/
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
