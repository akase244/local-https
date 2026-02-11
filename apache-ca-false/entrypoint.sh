#!/bin/sh
set -e

CERT_DIR="/usr/local/apache2/conf/certs"
ROOTCA_CERT_NAME="snakeoil_Development_Root_CA"
ROOTCA_CERT_KEY="${CERT_DIR}/${ROOTCA_CERT_NAME}.key"
ROOTCA_CERT_CRT="${CERT_DIR}/${ROOTCA_CERT_NAME}.crt"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"
SERVER_CERT_CSR="${CERT_DIR}/${SERVER_CERT_NAME}.csr"

mkdir -p "$CERT_DIR"

if [ ! -f "${ROOTCA_CERT_KEY}" ] || [ ! -f "${ROOTCA_CERT_CRT}" ]; then
  echo "generating ca certificate..."

  openssl genrsa -out "${ROOTCA_CERT_KEY}" 4096

  openssl req -x509 -new -nodes \
    -key "${ROOTCA_CERT_KEY}" \
    -sha256 \
    -days 3650 \
    -out "${ROOTCA_CERT_CRT}" \
    -subj "/C=JP/ST=Tokyo/L=Chiyoda/O=Snakeoil Development/CN=Local Development Root CA"

  chmod 600 "${ROOTCA_CERT_KEY}"
  chmod 644 "${ROOTCA_CERT_CRT}"
else
  echo "ca certificate already exists"
fi

if [ ! -f "${SERVER_CERT_KEY}" ] || [ ! -f "${SERVER_CERT_CRT}" ]; then
  echo "generating server certificate..."

  openssl genrsa -out "${SERVER_CERT_KEY}" 4096

  cat > "${CERT_DIR}/openssl.cnf" <<EOF
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = v3_req

[dn]
C = JP
ST = Tokyo
L = Chiyoda
O = Snakeoil Development
CN = localhost

[v3_req]
subjectAltName = @alt_names
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth

[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
IP.2 = ::1
EOF

  openssl req -new \
    -key "${SERVER_CERT_KEY}" \
    -out "${SERVER_CERT_CSR}" \
    -config "${CERT_DIR}/openssl.cnf"

  openssl x509 -req \
    -in "${SERVER_CERT_CSR}" \
    -CA "${ROOTCA_CERT_CRT}" \
    -CAkey "${ROOTCA_CERT_KEY}" \
    -CAcreateserial \
    -out "${SERVER_CERT_CRT}" \
    -days 365 \
    -sha256 \
    -extensions v3_req \
    -extfile "${CERT_DIR}/openssl.cnf"

  chmod 600 "${SERVER_CERT_KEY}"
  chmod 644 "${SERVER_CERT_CRT}"

else
  echo "server certificate already exists"
fi

exec "$@"
