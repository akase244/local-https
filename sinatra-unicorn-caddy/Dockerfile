FROM ruby:3.3

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    BUNDLE_PATH=/bundle

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile ./
RUN bundle install

COPY . .

RUN chmod +x entrypoint.sh

EXPOSE 4567

ENTRYPOINT ["./entrypoint.sh"]