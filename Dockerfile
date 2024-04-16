FROM alpine:3.10 AS ip-whitelist-on-hetznerfw

LABEL authors="Adnan Al Jawabra"

COPY entrypoint.sh /entrypoint.sh
COPY cleanup.sh /cleanup.sh

RUN apk update

RUN apk add --no-cache bash curl jq

RUN chmod +x /entrypoint.sh
RUN chmod +x /cleanup.sh

ENTRYPOINT ["/entrypoint.sh"]
