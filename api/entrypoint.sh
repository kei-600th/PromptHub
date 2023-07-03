#!/bin/sh
set -e

# server.pidの削除
rm -f /app/tmp/pids/server.pid

# マイグレーションを実行
bundle exec rails db:migrate

# railsサーバーを起動
exec bundle exec rails s -p $API_PORT -b '0.0.0.0'
