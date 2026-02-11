#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
ROOTCA_CERT_NAME="snakeoil_Development_Root_CA"
ROOTCA_CERT_KEY="${CERT_DIR}/${ROOTCA_CERT_NAME}.key"
ROOTCA_CERT_CRT="${CERT_DIR}/${ROOTCA_CERT_NAME}.crt"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"

mkdir -p "$CERT_DIR"

if [ ! -f "${ROOTCA_CERT_KEY}" ] || [ ! -f "${ROOTCA_CERT_CRT}" ]; then
  echo "generating certificate..."

  # basicConstraints に CA:TRUE が指定されているためルート証明書として発行される
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
    -keyout "${ROOTCA_CERT_KEY}" \
    -out "${ROOTCA_CERT_CRT}" \
    -config "${CERT_DIR}/openssl.cnf"

  chmod 600 "${ROOTCA_CERT_KEY}"
  chmod 644 "${ROOTCA_CERT_CRT}"

  ln -sf ${ROOTCA_CERT_KEY} ${SERVER_CERT_KEY}
  ln -sf ${ROOTCA_CERT_CRT} ${SERVER_CERT_CRT}
else
  echo "certificate already exists"
fi

exec "$@"
