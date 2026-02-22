#!/bin/sh
set -e

CERT_DIR="/certs"
ROOTCA_CERT_NAME="snakeoil_Development_Root_CA"
ROOTCA_CERT_KEY="${CERT_DIR}/${ROOTCA_CERT_NAME}.key"
ROOTCA_CERT_CRT="${CERT_DIR}/${ROOTCA_CERT_NAME}.crt"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"

export VAULT_ADDR=http://127.0.0.1:8200
export VAULT_TOKEN=root

vault server -dev &
VAULT_PID=$!

until vault status >/dev/null 2>&1; do
  sleep 1
done

vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki

vault write pki/root/generate/internal \
  common_name="Local Development Root CA" \
  ttl=87600h

vault read -field=certificate pki/cert/ca > ${ROOTCA_CERT_CRT}

chmod 644 "${ROOTCA_CERT_CRT}"

vault write pki/roles/nginx \
  allowed_domains="127.0.0.1,localhost" \
  allow_subdomains=true \
  allow_localhost=true \
  allow_ip_sans=true \
  max_ttl="720h"

vault write -format=json pki/issue/nginx \
  common_name="localhost" \
  alt_names="localhost" \
  ip_sans="127.0.0.1" \
  ttl="168h" \
  > /tmp/cert.json

jq -r '.data.private_key' /tmp/cert.json > ${SERVER_CERT_KEY}
jq -r '.data.certificate' /tmp/cert.json > ${SERVER_CERT_CRT}

chmod 600 "${SERVER_CERT_KEY}"
chmod 644 "${SERVER_CERT_CRT}"

wait $VAULT_PID
