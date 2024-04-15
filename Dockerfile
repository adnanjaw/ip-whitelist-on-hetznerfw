FROM alpine:3.10

LABEL authors="Adnan AL Jawabra"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
