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
end
