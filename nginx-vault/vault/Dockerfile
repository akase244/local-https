FROM hashicorp/vault:latest

RUN apk add --no-cache bash jq curl

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]