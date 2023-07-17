FROM ruby:2.7.2-alpine

ARG WORKDIR
ARG API_PORT
ARG RUNTIME_PACKAGES="nodejs tzdata mysql-client mysql-dev git nginx sudo"
ARG DEV_PACKAGES="build-base curl-dev"

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR ${HOME}

COPY Gemfile Gemfile.lock ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4

    # rubocop導入に伴い以下の処理を削除
    # apk del build-dependencies

# nginx
RUN rm -rf /var/cache/apk/* && \
    mkdir -p /var/log/nginx && \
    mkdir -p /var/www/html && \
    mkdir -p /app/tmp/sockets && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /var/www/html && \
    chmod 755 /var/www/html

COPY nginx/nginx.conf /etc/nginx/nginx.conf


COPY . ./


# 本番環境用の設定

# エントリーポイントを設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE ${API_PORT}

CMD ["/usr/bin/entrypoint.sh"]