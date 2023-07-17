#!/bin/sh
set -e

# server.pidの削除
rm -f /app/tmp/pids/server.pid

# マイグレーションを実行
bundle exec rails db:migrate

sudo service nginx start
cd /app
bin/setup
bundle exec pumactl start
