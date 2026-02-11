FROM nginx:stable

RUN apt-get update && \
    apt-get install -y openssl && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://dl.smallstep.com/gh-release/cli/gh-release-header/v0.29.0/step-cli_0.29.0-1_amd64.deb \
      -o step-cli.deb && \
    dpkg -i step-cli.deb && \
    rm step-cli.deb

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
