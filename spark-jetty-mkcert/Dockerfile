FROM amazoncorretto:25-alpine

WORKDIR /app

RUN apk add --no-cache \
    ca-certificates \
    nss \
    curl \
    openssl \
    maven

RUN curl -L https://dl.filippo.io/mkcert/latest?for=linux/amd64 \
      -o /usr/local/bin/mkcert && \
    chmod +x /usr/local/bin/mkcert

COPY pom.xml .
COPY src ./src
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
 && mvn -q package

EXPOSE 4567

ENTRYPOINT ["/entrypoint.sh"]