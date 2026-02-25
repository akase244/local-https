#!/bin/bash
set -e

export CAROOT="/mkcert"

CERT_DIR=/certs
SERVER_CERT_NAME="snakeoil"
SERVER_CERT_KEY="${CERT_DIR}/${SERVER_CERT_NAME}.key"
SERVER_CERT_CRT="${CERT_DIR}/${SERVER_CERT_NAME}.crt"

mkdir -p $CERT_DIR

if [ ! -f "${SERVER_CERT_KEY}" ] || [ ! -f "${SERVER_CERT_CRT}" ]; then
  mkcert \
    -key-file "${SERVER_CERT_KEY}" \
    -cert-file "${SERVER_CERT_CRT}" \
    localhost 127.0.0.1

  chmod 600 "${SERVER_CERT_KEY}"
  chmod 644 "${SERVER_CERT_CRT}"
fi

if [ ! -f "/app/config/application.rb" ]; then
  rails new . \
    --database=sqlite3 \
    --skip-test \
    --skip-bundle
  bundle install
fi

bundle exec rails db:prepare

exec bundle exec puma \
  -b "ssl://0.0.0.0:3000?key=${SERVER_CERT_KEY}&cert=${SERVER_CERT_CRT}"