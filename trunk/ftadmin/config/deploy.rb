require "bundler/capistrano"

set :application, "bioblitz"
set :repository,  "http://bioblitz.googlecode.com/svn/trunk/ftadmin"
set :scm, :subversion

default_run_options[:pty] = true

role :app, "178.79.142.149"
set :keep_releases, 5
set :user, 'ubuntu'

set :deploy_to, "/home/ubuntu/www/#{application}"

desc "Restart Application"
deploy.task :restart, :roles => [:app] do
  run "touch #{current_path}/tmp/restart.txt"
end

desc "Migraciones"
task :run_migrations, :roles => [:app] do
  run <<-CMD
    export RAILS_ENV=production &&
    cd #{release_path} &&
    rake db:migrate
  CMD
end

after  "deploy:update_code", :db_symlink, :run_migrations

task :db_symlink, :roles => [:app] do
  run <<-CMD
    ln -s #{shared_path}/db/production.sqlite3 #{release_path}/db;
  CMD
end

