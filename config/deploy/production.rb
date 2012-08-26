set :rails_env, 'production'
set :deploy_to, "/home/u/share/htdocs/#{application}"

default_run_options[:pty] = true

role :web, "v.u3u.jp"
role :app, "v.u3u.jp"
role :db,  "v.u3u.jp", :primary => true

set :unicorn_script, "#{deploy_to}/current/script/unicorn/release"
set :unicorn_conf,   "#{deploy_to}/current/config/unicorn/release.rb"
set :unicorn_pid,    "#{deploy_to}/current/tmp/pids/unicorn.pid"
