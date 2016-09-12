FROM alpine:latest

RUN echo "http://mirrors.ustc.edu.cn/alpine/v3.3/main" > /etc/apk/repositories && \
    echo "http://mirrors.ustc.edu.cn/alpine/v3.3/community" >> /etc/apk/repositories && \
    apk update

RUN apk add logrotate


