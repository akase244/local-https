#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"

while [ ! -f "${SERVER_CERT_KEY}" ] || [ ! -f "${SERVER_CERT_CRT}" ]; do
  sleep 1
done

exec "$@"
