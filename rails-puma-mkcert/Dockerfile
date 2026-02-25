FROM ruby:latest

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    sqlite3 \
    libsqlite3-dev \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://dl.filippo.io/mkcert/latest?for=linux/amd64 \
      -o /usr/local/bin/mkcert && \
    chmod +x /usr/local/bin/mkcert

WORKDIR /app

RUN gem update --system && gem install bundler

COPY Gemfile ./
RUN bundle install

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
