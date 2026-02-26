FROM golang:latest

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://dl.filippo.io/mkcert/latest?for=linux/amd64 \
      -o /usr/local/bin/mkcert && \
    chmod +x /usr/local/bin/mkcert

COPY go.mod ./
RUN go mod tidy

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY . .
RUN go mod tidy

EXPOSE 8443

ENTRYPOINT ["/entrypoint.sh"]
