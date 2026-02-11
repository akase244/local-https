#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
ROOTCA_CERT_NAME="snakeoil_Development_Root_CA"
ROOTCA_CERT_KEY="${ROOTCA_CERT_NAME}.key"
ROOTCA_CERT_CRT="${ROOTCA_CERT_NAME}.crt"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${SERVER_CERT_NAME}.crt"

mkdir -p "$CERT_DIR"
cd "${CERT_DIR}"

if [ ! -f "${ROOTCA_CERT_KEY}" ] || [ ! -f "${ROOTCA_CERT_CRT}" ]; then
  echo "generating ca certificate..."

  step certificate create \
    "Local Development Root CA" \
    "${ROOTCA_CERT_CRT}" \
    "${ROOTCA_CERT_KEY}" \
    --profile root-ca \
    --no-password \
    --insecure \
    --not-after 87600h

  chmod 600 "${ROOTCA_CERT_KEY}"
  chmod 644 "${ROOTCA_CERT_CRT}"
else
  echo "ca certificate already exists"
fi

if [ ! -f "${SERVER_CERT_KEY}" ] || [ ! -f "${SERVER_CERT_CRT}" ]; then
  echo "generating server certificate..."

  step certificate create \
    localhost \
    "${SERVER_CERT_CRT}" \
    "${SERVER_CERT_KEY}" \
    --profile leaf \
    --ca "${ROOTCA_CERT_CRT}" \
    --ca-key "${ROOTCA_CERT_KEY}" \
    --no-password \
    --insecure \
    --not-after 8760h \
    --san localhost \
    --san 127.0.0.1 \
    --san ::1

  chmod 600 "${SERVER_CERT_KEY}"
  chmod 644 "${SERVER_CERT_CRT}"
else
  echo "server certificate already exists"
fi

exec "$@"
