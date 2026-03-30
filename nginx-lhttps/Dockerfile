FROM php:7-cli-bullseye

RUN apt-get update && \
    apt-get install -y \
    git \
    unzip \
    curl \
    openssl \
    libssl-dev \
    libxml2-dev \
    libonig-dev \
    && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install \
    dom \
    mbstring

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN composer config --global audit.block-insecure false
RUN git clone https://github.com/madeny/lhttps.git /lhttps && \
    cd /lhttps && \
    composer install --no-dev --no-interaction

WORKDIR /lhttps

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
