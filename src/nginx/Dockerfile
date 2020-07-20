FROM nginx:1.19.0-alpine

RUN apk --no-cache add bash

COPY wait-for-it.sh /usr/bin/wait-for-it.sh
RUN chmod +x /usr/bin/wait-for-it.sh

COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD ./usr/bin/wait-for-it.sh -t 0 mysql:3306 -- nginx -g 'daemon off;'