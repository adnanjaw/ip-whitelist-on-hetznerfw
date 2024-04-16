FROM alpine:3.10 AS base-ip-whitelist-on-hetznerfw

LABEL authors="Adnan AL Jawabra"

COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache bash

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
