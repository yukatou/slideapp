set :application, "slideapp"
set :use_sudo, true 
set :user do Capistrano::CLI.ui.ask("user:") end
set :scm_user do Capistrano::CLI.ui.ask("scm user:") end
set :scm_password do Capistrano::CLI.password_prompt("scm pass:") end

set :default_environment, {
  #"PATH" => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH",
  "PATH" => "/home/u/bin:$PATH"
}

# ssh
ssh_options[:paranoid] = false
#ssh_options[:auth_methods] = ["publickey"]
ssh_options[:port] = 22

# Git
set :scm, :git
set :repository, "git@github.com:yukatou/slideapp.git"
set :branch, "master"

# Bundle
set :bundle_cmd, "/home/u/bin/bundle"
set :bundle_without, [:development, :test]

# Deploy 
set :deploy_via, :copy
after :deploy, "deploy:cleanup"
after "deploy:setup" do
  run <<-CMD
    mkdir -p "#{shared_path}/run"
  CMD
end

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{unicorn_script} start #{rails_env}"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "#{unicorn_script} stop"
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "#{unicorn_script} graceful_stop"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{unicorn_script} reload"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && #{unicorn_script} restart"
  end
  
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path} && /usr/bin/env bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
  
  desc "Restart Resque Workers"
  task :restart_workers, :roles => :db do
    run_remote_rake "resque:restart_workers"
  end
end



after "deploy:symlink", "deploy:restart_workers"

##
# Rake helper task.
# http://pastie.org/255489
# http://geminstallthat.wordpress.com/2008/01/27/rake-tasks-through-capistrano/
# http://ananelson.com/said/on/2007/12/30/remote-rake-tasks-with-capistrano/
def run_remote_rake(rake_cmd)
  rake_args = ENV['RAKE_ARGS'].to_s.split(',')
  cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
  cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
  run cmd
  set :rakefile, nil if exists?(:rakefile)
end


