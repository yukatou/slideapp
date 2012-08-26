# -*- coding: utf-8 -*-

#proj_root_dir = File.expand_path("../../../../", __FILE__)

# ワーカーの数
worker_processes 4

# ソケット経由で通信する
listen File.expand_path('../../shared/run/universe.sock', ENV['RAILS_ROOT'])

# PID
pid File.expand_path('tmp/pids/unicorn.pid', ENV['RAILS_ROOT'])

# ログ
stderr_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])

#listen      "#{proj_root_dir}/shared/run/universe.sock"
#pid         "#{proj_root_dir}/current/tmp/pids/unicorn.pid"
#stderr_path "#{proj_root_dir}/current/log/unicorn.log"
#stdout_path "#{proj_root_dir}/current/log/unicorn.log"

# ダウンタイムなくす
preload_app true

# graceful restart用の設定 (Masterプロセスがシームレスに切り替わる)
before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  # oldプロセスがいたら終了する
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
