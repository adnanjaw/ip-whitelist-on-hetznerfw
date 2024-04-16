FROM alpine:3.10 AS base-ip-whitelist-on-hetznerfw

LABEL authors="Adnan AL Jawabra"

COPY entrypoint.sh /entrypoint.sh

RUN apk update

RUN apk add --no-cache bash curl jq

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
