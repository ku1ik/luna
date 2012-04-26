require 'rvm/capistrano'
require 'bundler/capistrano'

set :application, "luna"
set :repository,  "git@github.com:sickill/luna.git"

set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false
set :rails_env, "production"
set :user, "luna"
set :deploy_to, "~/app"

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "luna.com"                          # Your HTTP server, Apache/etc
role :app, "luna.com"                          # This may be the same as your `Web` server
role :db,  "luna.com", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
set :keep_releases, 3

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Symlink shared/* files"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:update_code", "deploy:symlink_shared"
