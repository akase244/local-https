#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
CERT_NAME="snakeoil"
KEY="${CERT_DIR}/${CERT_NAME}.key"
CRT="${CERT_DIR}/${CERT_NAME}.crt"

mkdir -p "$CERT_DIR"

if [ ! -f "${KEY}" ] || [ ! -f "${CRT}" ]; then
  echo "generating certificate..."

  openssl req \
    -x509 \
    -nodes \
    -days 3650 \
    -newkey rsa:4096 \
    -keyout "${KEY}" \
    -out "${CRT}" \
    -subj "/C=JP/ST=Tokyo/L=Localhost/O=Snakeoil/OU=Dev/CN=localhost" \
    -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"

  chmod 600 "${KEY}"
  chmod 644 "${CRT}"
else
  echo "certificate already exists"
fi

exec "$@"

