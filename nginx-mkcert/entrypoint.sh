#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"

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
else
  echo "certificate already exists"
fi

exec "$@"
