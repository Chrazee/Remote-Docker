FROM alpine

RUN apk --no-cache add \
    bash curl git \
    php7 php7-json php7-session php7-dom php7-mbstring php7-gd php7-tokenizer php7-phar php7-curl \
    php7-xml php7-xmlreader php7-xmlwriter \
    php7-pdo php7-pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    chmod +x /usr/bin/composer

COPY setup.sh /usr/bin/setup.sh
RUN chmod +x /usr/bin/setup.sh

VOLUME /var/www/html

WORKDIR /var/www/html

