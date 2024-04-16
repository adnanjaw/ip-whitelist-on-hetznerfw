FROM alpine:3.10

LABEL authors="Adnan AL Jawabra"

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
