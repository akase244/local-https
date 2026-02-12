#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
ROOTCA_CERT_NAME="snakeoil_Development_Root_CA"
ROOTCA_CERT_KEY="${CERT_DIR}/${ROOTCA_CERT_NAME}.key"
ROOTCA_CERT_CRT="${CERT_DIR}/${ROOTCA_CERT_NAME}.crt"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"
CERTSTRAP_DIR="/tmp/certstrap"

mkdir -p "${CERT_DIR}"
mkdir -p "${CERTSTRAP_DIR}"
cd "${CERTSTRAP_DIR}"

if [ ! -f "${ROOTCA_CERT_KEY}" ] || [ ! -f "${ROOTCA_CERT_CRT}" ]; then
  echo "generating ca certificate..."

  certstrap init \
    --common-name localhost \
    --organization "Snakeoil Development" \
    --organizational-unit "Snakeoil Development" \
    --country "JP" \
    --province "Tokyo" \
    --locality "Chiyoda" \
    --expires "3650 days" \
    --key-bits 4096 \
    --passphrase ""

  cp "out/localhost.crt" "${ROOTCA_CERT_CRT}"
  cp "out/localhost.key" "${ROOTCA_CERT_KEY}"

  chmod 600 "${ROOTCA_CERT_KEY}"
  chmod 644 "${ROOTCA_CERT_CRT}"
else
  echo "ca certificate already exists"
fi

if [ ! -f "${SERVER_CERT_KEY}" ] || [ ! -f "${SERVER_CERT_CRT}" ]; then
  echo "generating server certificate..."

  certstrap request-cert \
    --common-name server \
    --organization "Snakeoil Development" \
    --organizational-unit "Snakeoil Development" \
    --country "JP" \
    --province "Tokyo" \
    --locality "Chiyoda" \
    --domain "localhost" \
    --ip "127.0.0.1" \
    --ip "::1" \
    --passphrase ""

  certstrap sign server --CA localhost --passphrase ""

  cp "out/server.key" "${SERVER_CERT_KEY}"
  cp "out/server.crt" "${SERVER_CERT_CRT}"

  chmod 600 "${SERVER_CERT_KEY}"
  chmod 644 "${SERVER_CERT_CRT}"
else
  echo "server certificate already exists"
fi

exec "$@"
