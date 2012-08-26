# 複数のデプロイ環境の作成をサポート
require "capistrano/ext/multistage"
# デプロイ時にbundle install実行する
require 'bundler/capistrano'
# resque
require "capistrano-resque"

load 'deploy'

# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy' # remove this line to skip loading any of the default tasks }
