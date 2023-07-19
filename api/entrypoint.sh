#!/bin/sh
set -e

# server.pidの削除
rm -f /app/tmp/pids/server.pid

# マイグレーションを実行
bundle exec rails db:migrate

# Railsサーバーをバックグラウンドで起動
bundle exec puma -C config/puma.rb

# nginxをフォアグラウンドで起動
# exec nginx -g 'daemon off;'
