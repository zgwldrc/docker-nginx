# From Which Image
FROM alpine:latest

# Set Repos Info
RUN wget http://sh.xiayu.site/mirror/ustc/alpine.sh -O /tmp/alpine.sh && sh /tmp/alpine.sh && apk update $$ rm -f /tmp/alpine.sh

# Install Pkgs Needed
RUN apk add --no-cache --virtual .build-deps \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    curl \
    jemalloc-dev \
    gd-dev \
    git

# Set Nginx Version Variable
ENV NGINX_VERSION 1.9.14

# Download Nginx and Modules
RUN mkdir -p /var/run/nginx/
RUN wget -c http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN git clone https://github.com/cuber/ngx_http_google_filter_module.git
RUN git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git
RUN git clone https://github.com/aperezdc/ngx-fancyindex.git
RUN git clone https://github.com/yaoweibin/nginx_upstream_check_module.git

# Install Nginx
RUN tar -xzvf nginx-${NGINX_VERSION}.tar.gz && \
cd nginx-${NGINX_VERSION} && \
cd src/ && \
# Patching
patch -p1 < /nginx_upstream_check_module/check_1.9.2+.patch && \
cd .. && \
# Compile and Install
./configure --prefix=/usr/local/nginx \
--with-pcre \
--with-ipv6 \
--with-http_ssl_module \
--with-http_flv_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--with-http_mp4_module \
--with-http_image_filter_module \
--with-http_addition_module \
--with-http_sub_module  \
--with-http_dav_module  \
--http-client-body-temp-path=/usr/local/nginx/client/ \
--http-proxy-temp-path=/usr/local/nginx/proxy/ \
--http-fastcgi-temp-path=/usr/local/nginx/fcgi/ \
--http-uwsgi-temp-path=/usr/local/nginx/uwsgi \
--http-scgi-temp-path=/usr/local/nginx/scgi \
--add-module=../ngx_http_google_filter_module \
--add-module=../ngx_http_substitutions_filter_module \
--add-module=../ngx-fancyindex \
--add-module=../nginx_upstream_check_module \
--with-ld-opt="-ljemalloc" && \
# make and make install
make -j $(nproc) && make install && \

# Make Temp/Cache dir and Do cleaning 
mkdir -p /usr/local/nginx/cache/ && \
mkdir -p /usr/local/nginx/temp/ && \
rm -rf ../{ngx*,nginx*}

# Setup container env
RUN apk add logrotate supervisor vim bash tzdata && \
    wget -O /etc/logrotate.d/nginx http://sh.xiayu.site/logrotate/nginx && \
    mkdir -p /etc/supervisor.d/ && \
    wget -O /etc/supervisor.d/supervisord.ini  http://sh.xiayu.site/supervisor/docker-alpine-nginx-supervisord.ini && \
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime -f
    
# Set Default Start Command
CMD ["/usr/bin/supervisord"]
