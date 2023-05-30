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

COPY package*.json ./
RUN yarn install

ADD . ${HOME}
EXPOSE ${FRONT_PORT}
RUN yarn run build
CMD ["yarn", "start"]