#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
ROOTCA_CERT_NAME="snakeoil_Development_Root_CA"
ROOTCA_CERT_KEY="${CERT_DIR}/${ROOTCA_CERT_NAME}.key"
ROOTCA_CERT_CRT="${CERT_DIR}/${ROOTCA_CERT_NAME}.crt"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"
SERVER_CERT_CSR="${CERT_DIR}/${SERVER_CERT_NAME}.csr"
PKI_DIR="/tmp/easy_rsa"

mkdir -p "$CERT_DIR"

if [ ! -f "${ROOTCA_CERT_KEY}" ] || [ ! -f "${ROOTCA_CERT_CRT}" ] || [ ! -f "${SERVER_CERT_KEY}" ] || [ ! -f "${SERVER_CERT_CRT}" ]; then
  echo "generating certificate..."

  make-cadir "${PKI_DIR}"
  cd "${PKI_DIR}"

  cat > vars <<EOF
set_var EASYRSA_REQ_COUNTRY    "JP"
set_var EASYRSA_REQ_PROVINCE   "Tokyo"
set_var EASYRSA_REQ_CITY       "Chiyoda"
set_var EASYRSA_REQ_ORG        "Snakeoil"
set_var EASYRSA_REQ_EMAIL      "admin@localhost"
set_var EASYRSA_REQ_OU         "Development"
set_var EASYRSA_ALGO           "rsa"
set_var EASYRSA_DIGEST         "sha256"
EOF

  ./easyrsa init-pki

  ./easyrsa --batch build-ca nopass

  ./easyrsa --batch --subject-alt-name="DNS:localhost,IP:127.0.0.1" build-server-full server nopass

  cp pki/ca.crt "${ROOTCA_CERT_CRT}"
  cp pki/issued/server.crt "${SERVER_CERT_CRT}"
  cp pki/private/server.key "${SERVER_CERT_KEY}"

  chmod 644 "${ROOTCA_CERT_CRT}"
else
  echo "certificate already exists"
fi

exec "$@"
