FROM alpine:3.15

RUN apk add --update openssh-client autossh && rm -rf /var/cache/apk/*

EXPOSE 1-65535

COPY /entrypoint.sh /

ENTRYPOINT ["/bin/sh", "-c", "/entrypoint.sh"]
