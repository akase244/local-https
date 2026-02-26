#!/bin/sh
set -e

CERT_DIR="/certs"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"
KEYSTORE="${CERT_DIR}/keystore.p12"
PASSWORD="spark-jetty-mkcert"

export CAROOT="/mkcert"

mkdir -p "${CERT_DIR}"

if [ ! -f "${SERVER_CERT_KEY}" ] || [ ! -f "${SERVER_CERT_CRT}" ]; then
  echo "generating certificate..."

  mkcert \
    -key-file "${SERVER_CERT_KEY}" \
    -cert-file "${SERVER_CERT_CRT}" \
    localhost 127.0.0.1

  chmod 600 "${SERVER_CERT_KEY}"
  chmod 644 "${SERVER_CERT_CRT}"

  openssl pkcs12 -export \
    -in "${SERVER_CERT_CRT}" \
    -inkey "${SERVER_CERT_KEY}" \
    -out "${KEYSTORE}" \
    -name jetty \
    -password pass:${PASSWORD}
else
  echo "certificate already exists"
fi

java \
  -Djavax.net.ssl.keyStore=${KEYSTORE} \
  -Djavax.net.ssl.keyStorePassword=${PASSWORD} \
  -jar target/spark-jetty.jar