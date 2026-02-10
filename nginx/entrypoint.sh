#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
CERT_NAME="snakeoil"
SERVER_KEY="${CERT_DIR}/${CERT_NAME}.key"
SERVER_CRT="${CERT_DIR}/${CERT_NAME}.crt"

mkdir -p "$CERT_DIR"

if [ ! -f "${SERVER_KEY}" ] || [ ! -f "${SERVER_CRT}" ]; then
  echo "generating certificate..."

  # basicConstraints に CA:TRUE が指定されているため、このサーバー証明書はCA証明書として機能します
  cat > "${CERT_DIR}/openssl.cnf" <<EOF
[req]
default_bits = 4096
prompt = no
default_md = sha256
distinguished_name = dn
x509_extensions = v3_ca

[dn]
C = JP
ST = Tokyo
L = Localhost
O = Snakeoil
OU = Development
CN = localhost

[v3_ca]
subjectAltName = @alt_names
basicConstraints = critical,CA:TRUE
keyUsage = critical,digitalSignature,keyEncipherment,keyCertSign
extendedKeyUsage = serverAuth

[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
IP.2 = ::1
EOF

  openssl req -x509 -nodes -days 365 \
    -newkey rsa:4096 \
    -keyout "${SERVER_KEY}" \
    -out "${SERVER_CRT}" \
    -config "${CERT_DIR}/openssl.cnf"

  chmod 600 "${SERVER_KEY}"
  chmod 644 "${SERVER_CRT}"
else
  echo "certificate already exists"
fi

exec "$@"
