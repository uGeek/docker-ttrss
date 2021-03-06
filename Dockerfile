FROM alpine:3.10.0

LABEL maintainer="angel <ugeekpodcast@gmail.com>" \
    org.label-schema.name="TT-RSS" \
    org.label-schema.version="1.2" \
    org.label-schema.vendor="Robert Kaussow" \
    org.label-schema.schema-version="1.0"

ARG TTRSS_VERSION=master
ARG TTRSS_TARBALL=https://git.tt-rss.org/git/tt-rss/archive/${TTRSS_VERSION}.tar.gz

RUN apk --update add --virtual .build-deps tar curl && \
    apk --update add s6 nginx ca-certificates ssmtp mailx php7 php7-curl \
    php7-fpm php7-xml php7-dom php7-opcache php7-iconv php7-pdo php7-pdo_mysql php7-mysqli php7-mysqlnd \
    php7-pdo_pgsql php7-pgsql php7-gd php7-mcrypt php7-posix php7-ldap php7-json php7-mbstring \
    php7-session php7-fileinfo php7-intl php7-pcntl && \
    rm -rf /var/www/localhost && \
    rm -f /etc/php7/php-fpm.d/www.conf && \
    mkdir -p /var/www/app && \
    curl -SsL -o /usr/local/bin/gomplate https://github.com/hairyhenderson/gomplate/releases/download/v3.5.0/gomplate_linux-amd64-slim && \
    chmod 755 /usr/local/bin/gomplate && \
    curl -SsL ${TTRSS_TARBALL} | tar xz -C /var/www/app/ --strip-components=1 && \
    curl -SsL -o /etc/php7/browscap.ini https://browscap.org/stream?q=Lite_PHP_BrowsCapINI && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    mkdir -p /var/lib/php/tmp_upload && \
    mkdir -p /var/lib/php/soap_cache && \
    mkdir -p /var/lib/php/session && \
    chown -R nginx:nginx /var/lib/php/tmp_upload && \
    chown -R nginx:nginx /var/lib/php/soap_cache && \
    chown -R nginx:nginx /var/lib/php/session

ADD overlay/ /

VOLUME /var/www/app/plugins.local
VOLUME /var/www/app/feed-icons
VOLUME /var/www/app/themes.local

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD /usr/local/bin/healthcheck.sh
WORKDIR /var/www/app
CMD []
