FROM alpine:3.19.0

RUN apk update \
    && apk add --no-cache git\
    && rm -rf /var/cache/apk/*

CMD ["/bin/sh"]