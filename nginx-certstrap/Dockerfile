FROM nginx:stable

RUN apt-get update && \
    apt-get install -y openssl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/square/certstrap/releases/download/v1.3.0/certstrap-linux-amd64 \
      -o /usr/local/bin/certstrap && \
    chmod +x /usr/local/bin/certstrap

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
