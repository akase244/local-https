#!/bin/sh
set -e

DOMAIN="localhost"
LHTTPS_DIR="/lhttps"

CERT_DIR="/etc/nginx/certs"
ROOTCA_CERT_NAME="snakeoil_Development_Root_CA"
ROOTCA_CERT_CRT="${CERT_DIR}/${ROOTCA_CERT_NAME}.crt"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"

mkdir -p "${CERT_DIR}"
cd "${LHTTPS_DIR}"

if [ ! -f "${ROOTCA_CERT_CRT}" ] || [ ! -f "${SERVER_CERT_KEY}" ] || [ ! -f "${SERVER_CERT_CRT}" ]; then
  echo "generating certificate..."

  cat > ".env" <<EOF
R="[req]"
D="default_bits = 4096"
P="prompt = no"
DM="default_md = sha256"
DN="distinguished_name = dn"
D2="[dn]"
COUNTRY="C=JP"
STATE="ST=Tokyo"
LOCALITY="L=Chiyoda"
ORGANIZATION="O=Snakeoil Development"
ORGANIZATION_UNIT="OU=Snakeoil Development"
EMAILADDRESS="emailAddress=local@https.local"
COMMONNAME="CN=localhost"
EOF

  # cert/cnf/v3.ext,cert/cnf/openssl.cnfを生成
  php -r '
  require "vendor/autoload.php";
  new \Madeny\lhttps\Init("'"${DOMAIN}"'");
  new \Madeny\lhttps\Config("'"${DOMAIN}"'");
  ';

  # 証明書を生成
  php lh create "${DOMAIN}"

  cp "cert/csr/root.pem" "${ROOTCA_CERT_CRT}"
  cp "cert/live/${DOMAIN}.ssl.key" "${SERVER_CERT_KEY}"
  cp "cert/live/${DOMAIN}.ssl.crt" "${SERVER_CERT_CRT}"

  chmod 644 "${ROOTCA_CERT_CRT}"
  chmod 600 "${SERVER_CERT_KEY}"
  chmod 644 "${SERVER_CERT_CRT}"
else
  echo "certificate already exists"
fi

tail -f /dev/null
