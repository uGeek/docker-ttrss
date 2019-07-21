# [ttrss](https://gitea.rknet.org/docker/ttrss)

[![Build Status](https://drone.rknet.org/api/badges/docker/ttrss/status.svg)](https://drone.rknet.org/docker/ttrss/)
[![Microbadger](https://images.microbadger.com/badges/image/xoxys/ttrss.svg)](https://microbadger.com/images/xoxys/ttrss "Get your own image badge on microbadger.com")

TT-RSS is an open source web-based news feed (RSS/Atom) reader and aggregator, designed to allow you to read news from any location, while feeling as close to a real desktop application as possible.

## Usage

Here are some example snippets to help you get started creating a container.

> **WARNING**: For production usage you should secure your database and NOT use the default credentials!

### Docker

```Shell
docker create \
  --name=ttrss \
  -p 80:80 \
  xoxys/ttrss
```

### Docker Compose

Compatible with docker-compose v2 schemas.

```Yaml
---
version: '2.1'

services:
  ttrss:
    image: xoxys/ttrss:latest
    ports:
      - "80:80"
    depends_on:
      - db
    volumes:
      - ttrss_plugins:/var/www/app/plugins.local
      - ttrss_icons:/var/www/app/feed-icons
      - ttrss_themes:/var/www/app/themes.local

  db:
    image: postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: secure
      POSTGRES_DB: ttrss
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
    driver: local
  ttrss_plugins:
    driver: local
  ttrss_icons:
    driver: local
  ttrss_themes:
    driver: local
```

## Environment variables

### TT-RSS

```Shell
TTRSS_DB_TYPE=pgsql
TTRSS_DB_HOST=db
TTRSS_DB_USER=postgres
TTRSS_DB_NAME=ttrss
TTRSS_DB_PASS=secure
TTRSS_DB_PORT=5432
TTRSS_SELF_URL_PATH=http://localhost/
TTRSS_SINGLE_USER_MODE=false
TTRSS_SIMPLE_UPDATE_MODE=false
TTRSS_AUTH_AUTO_CREATE=true
TTRSS_AUTH_AUTO_LOGIN=true
TTRSS_FORCE_ARTICLE_PURGE=0
TTRSS_SPHINX_SERVER=localhost:9312
TTRSS_SPHINX_INDEX=ttrss, delta
TTRSS_ENABLE_REGISTRATION=false
TTRSS_REG_NOTIFY_ADDRESS=
TTRSS_REG_MAX_USERS=10;
TTRSS_SESSION_COOKIE_LIFETIME=86400
TTRSS_SMTP_FROM_NAME=Tiny Tiny RSS
TTRSS_SMTP_FROM_ADDRESS=
TTRSS_DIGEST_SUBJECT=[tt-rss] New headlines for last 24 hours
TTRSS_PLUGINS=auth_internal, note
```

### PHP

```Shell
PHP_EXPOSE_PHP=Off
PHP_MAX_EXECUTION_TIME=30
PHP_MAX_INPUT_TIME=60
PHP_MEMORY_LIMIT=50M
PHP_ERROR_REPORTING=E_ALL & ~E_DEPRECATED & ~E_STRICT
PHP_DISPLAY_ERRORS=Off
PHP_DISPLAY_STARTUP_ERRORS=Off
PHP_LOG_ERRORS=On
PHP_LOG_ERRORS_MAX_LEN=1024
PHP_IGNORE_REPEATED_ERRORS=Off
PHP_IGNORE_REPEATED_SOURCE=Off
PHP_REPORT_MEMLEAKS=On
PHP_HTML_ERRORSOn
PHP_ERROR_LOG=/proc/self/fd/2
PHP_POST_MAX_SIZE=8M
PHP_FILE_UPLOADS=Off
PHP_UPLOAD_MAX_FILESIZE=2M
PHP_MAX_FILE_UPLOADS=2
PHP_ALLOW_URL_FOPEN=On
PHP_ALLOW_URL_INCLUDE=Off
PHP_DATE_TIMEZONE=Europe/Berlin
PHP_SQL_SAFE_MODE=On
```

### License

This project is licensed under the MIT License - see the [LICENSE](https://gitea.rknet.org/docker/ttrss/src/branch/master/LICENSE) file for details.

### Maintainers and Contributors

[Robert Kaussow](https://gitea.rknet.org/xoxys)
