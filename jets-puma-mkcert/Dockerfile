FROM ruby:3.3.0

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    BUNDLE_PATH=/bundle

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L https://dl.filippo.io/mkcert/latest?for=linux/amd64 \
      -o /usr/local/bin/mkcert && \
    chmod +x /usr/local/bin/mkcert

RUN gem install bundler
COPY Gemfile ./
RUN bundle install

RUN bundle exec jets new . \
    --mode html \
    --database sqlite3 \
    --skip-git \
    --force

COPY app/controllers/hello_controller.rb app/controllers/hello_controller.rb
COPY config/routes.rb config/routes.rb
COPY config/puma.rb config/puma.rb

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

EXPOSE 9293

CMD ["./entrypoint.sh"]