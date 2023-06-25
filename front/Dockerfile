FROM node:16.13.1-alpine

ARG WORKDIR
ARG API_URL
ARG FRONT_PORT

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    HOST=0.0.0.0 \
    API_URL=${API_URL}

WORKDIR ${HOME}


# 本番環境用の設定
RUN apk update && \
    apk upgrade && \
    rm -rf /var/cache/apk/*

# 依存関係を先にコピー
COPY package*.json ./
RUN yarn install

# ソースコードは最後にコピー
COPY . ${HOME}

RUN yarn run build
EXPOSE ${FRONT_PORT}
CMD ["yarn", "start"]