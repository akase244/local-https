#!/bin/sh
set -e

DOMAINS="${DOMAIN:-localhost}"

MINICA_DIR="/tmp/minica"
MINICA_ROOTCA_CERT_KEY="minica-key.pem"
MINICA_ROOTCA_CERT_CRT="minica.pem"
MINICA_SERVER_CERT_KEY="key.pem"
MINICA_SERVER_CERT_CRT="cert.pem"

CERT_DIR="/etc/nginx/certs"
ROOTCA_CERT_NAME="snakeoil_Development_Root_CA"
ROOTCA_CERT_KEY="${CERT_DIR}/${ROOTCA_CERT_NAME}.key"
ROOTCA_CERT_CRT="${CERT_DIR}/${ROOTCA_CERT_NAME}.crt"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"

mkdir -p "${CERT_DIR}"
mkdir -p "${MINICA_DIR}"
cd "${MINICA_DIR}"

if [ ! -f "${MINICA_ROOTCA_CERT_KEY}" ] || [ ! -f "${MINICA_ROOTCA_CERT_CRT}" ]; then
  echo "generating certificate..."

  minica --domains "${DOMAINS}"

  FIRST_DOMAIN=$(echo "${DOMAINS}" | cut -d',' -f1)

  cp "${MINICA_ROOTCA_CERT_KEY}" "${ROOTCA_CERT_KEY}"
  cp "${MINICA_ROOTCA_CERT_CRT}" "${ROOTCA_CERT_CRT}"
  chmod 600 "${ROOTCA_CERT_KEY}"
  chmod 644 "${ROOTCA_CERT_CRT}"

  cp "${FIRST_DOMAIN}/${MINICA_SERVER_CERT_KEY}" "${SERVER_CERT_KEY}"
  cp "${FIRST_DOMAIN}/${MINICA_SERVER_CERT_CRT}" "${SERVER_CERT_CRT}"
  chmod 600 "${SERVER_CERT_KEY}"
  chmod 644 "${SERVER_CERT_CRT}"
else
  echo "certificate already exists"
fi

tail -f /dev/null