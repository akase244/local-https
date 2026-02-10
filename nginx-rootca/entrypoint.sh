#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
CA_NAME="rootCA"
CA_KEY="${CERT_DIR}/${CA_NAME}.key"
CA_CRT="${CERT_DIR}/${CA_NAME}.crt"
CERT_NAME="snakeoil"
SERVER_KEY="${CERT_DIR}/${CERT_NAME}.key"
SERVER_CRT="${CERT_DIR}/${CERT_NAME}.crt"
SERVER_CSR="${CERT_DIR}/${CERT_NAME}.csr"

mkdir -p "$CERT_DIR"

if [ ! -f "${CA_KEY}" ] || [ ! -f "${CA_CRT}" ]; then
  echo "generating ca certificate..."

  openssl genrsa -out "${CA_KEY}" 4096

  openssl req -x509 -new -nodes \
    -key "${CA_KEY}" \
    -sha256 \
    -days 3650 \
    -out "${CA_CRT}" \
    -subj "/C=JP/ST=Tokyo/L=Localhost/O=Snakeoil/OU = Development/CN=Local Development Root CA"

  chmod 600 "${CA_KEY}"
  chmod 644 "${CA_CRT}"
else
  echo "ca certificate already exists"
fi

if [ ! -f "${SERVER_KEY}" ] || [ ! -f "${SERVER_CRT}" ]; then
  echo "generating server certificate..."

  openssl genrsa -out "${SERVER_KEY}" 4096

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
L = Tokyo
O = Snakeoil
OU = Development
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
    -key "${SERVER_KEY}" \
    -out "${SERVER_CSR}" \
    -config "${CERT_DIR}/openssl.cnf"

  openssl x509 -req \
    -in "${SERVER_CSR}" \
    -CA "${CA_CRT}" \
    -CAkey "${CA_KEY}" \
    -CAcreateserial \
    -out "${SERVER_CRT}" \
    -days 365 \
    -sha256 \
    -extensions v3_req \
    -extfile "${CERT_DIR}/openssl.cnf"

  chmod 600 "${SERVER_KEY}"
  chmod 644 "${SERVER_CRT}"
else
  echo "server certificate already exists"
fi

exec "$@"
