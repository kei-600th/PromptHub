FROM ruby:2.7.2-alpine

ARG WORKDIR
ARG API_PORT
ARG RUNTIME_PACKAGES="nodejs tzdata mysql-client mysql-dev git nginx"
ARG DEV_PACKAGES="build-base curl-dev"

# sudoを使用するためのユーザー名とグループ名を指定
ARG USER=docker
ARG GROUP=docker

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR ${HOME}

COPY Gemfile Gemfile.lock ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    apk add --no-cache sudo && \
    bundle install -j4

    # rubocop導入に伴い以下の処理を削除
    # apk del build-dependencies

# sudoをパスワード無しで使用できるように設定を追加
RUN echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    addgroup ${GROUP} && \
    adduser -D -G ${GROUP} ${USER}

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