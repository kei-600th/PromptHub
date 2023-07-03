#!/bin/sh
set -e

# server.pidの削除
rm -f /app/tmp/pids/server.pid

# マイグレーションとシードを実行
bundle exec rails db:migrate
bundle exec rails db:seed

# railsサーバーを起動
exec bundle exec rails s -p $API_PORT -b '0.0.0.0'
