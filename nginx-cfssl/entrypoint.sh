#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"
ROOTCA_CERT_NAME="snakeoil_Development_Root_CA"
ROOTCA_CERT_KEY="${ROOTCA_CERT_NAME}-key.pem"
ROOTCA_CERT_CRT="${ROOTCA_CERT_NAME}.pem"
ROOTCA_CERT_CSR="${ROOTCA_CERT_NAME}.csr"
ROOTCA_CERT_CONFIG_JSON="${ROOTCA_CERT_NAME}-config.json"
ROOTCA_CERT_CSR_JSON="${ROOTCA_CERT_NAME}-csr.json"
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${SERVER_CERT_NAME}-key.pem"
SERVER_CERT_CRT="${SERVER_CERT_NAME}.pem"
SERVER_CERT_CSR="${SERVER_CERT_NAME}.csr"
SERVER_CERT_CSR_JSON="${SERVER_CERT_NAME}-csr.json"

mkdir -p "$CERT_DIR"
cd "${CERT_DIR}"

if [ ! -f "${ROOTCA_CERT_KEY}" ] || [ ! -f "${ROOTCA_CERT_CRT}" ]; then
  echo "generating ca certificate..."

  cat > "${ROOTCA_CERT_CONFIG_JSON}" <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "server": {
        "usages": ["signing", "key encipherment", "server auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

  cat > "${ROOTCA_CERT_CSR_JSON}" <<EOF
{
  "CN": "Local Development Root CA",
  "key": {
    "algo": "rsa",
    "size": 4096
  },
  "names": [
    {
      "C": "JP",
      "ST": "Tokyo",
      "L": "Chiyoda",
      "O": "Snakeoil Development"
    }
  ]
}
EOF

  cfssl gencert -initca "${ROOTCA_CERT_CSR_JSON}" | cfssljson -bare ${ROOTCA_CERT_NAME}

  chmod 600 "${ROOTCA_CERT_KEY}"
  chmod 644 "${ROOTCA_CERT_CRT}"
else
  echo "ca certificate already exists"
fi

if [ ! -f "${SERVER_CERT_KEY}" ] || [ ! -f "${SERVER_CERT_CRT}" ]; then
  echo "generating server certificate..."

  cat > "${SERVER_CERT_CSR_JSON}" <<EOF
{
  "CN": "localhost",
  "hosts": [
    "localhost",
    "127.0.0.1",
    "::1"
  ],
  "key": {
    "algo": "rsa",
    "size": 4096
  },
  "names": [
    {
      "C": "JP",
      "ST": "Tokyo",
      "L": "Chiyoda",
      "O": "Snakeoil Development"
    }
  ]
}
EOF

  cfssl gencert \
    -ca="${ROOTCA_CERT_CRT}" \
    -ca-key="${ROOTCA_CERT_KEY}" \
    -config="${ROOTCA_CERT_CONFIG_JSON}" \
    -profile=server \
    "${SERVER_CERT_CSR_JSON}" | cfssljson -bare "${SERVER_CERT_NAME}"

  chmod 600 "${SERVER_CERT_KEY}"
  chmod 644 "${SERVER_CERT_CRT}"
else
  echo "server certificate already exists"
fi

exec "$@"
