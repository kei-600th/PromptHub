FROM ruby:2.7.2-alpine

ARG WORKDIR
ARG API_PORT
ARG RUNTIME_PACKAGES="nodejs tzdata mysql-client mysql-dev git"
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
    bundle install -j4 && \
    apk del build-dependencies

COPY . ./


# 本番環境用の設定

EXPOSE ${API_PORT}

RUN rm -f /app/tmp/pids/server.pid

CMD rails server -p $API_PORT -b 0.0.0.0