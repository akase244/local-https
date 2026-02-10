#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
CERT_NAME="snakeoil"
KEY="${CERT_DIR}/${CERT_NAME}.key"
CRT="${CERT_DIR}/${CERT_NAME}.crt"

export CAROOT="/mkcert"

mkdir -p "${CERT_DIR}"

if [ ! -f "${KEY}" ] || [ ! -f "${CRT}" ]; then
  echo "generating certificate..."

  mkcert \
    -key-file "${KEY}" \
    -cert-file "${CRT}" \
    localhost 127.0.0.1

  chmod 600 "${KEY}"
  chmod 644 "${CRT}"
else
  echo "certificate already exists"
fi

exec "$@"
