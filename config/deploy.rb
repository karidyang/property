# -*- encoding : utf-8 -*-
require 'bundler/capistrano'
set :application, "property"
set :repository, "git://github.com/karidyang/property.git"
set :branch, "master"
set :scm, :git
set :user, 'karidyang' #部署的用户名，需要是可以访问github的用户
set :port, '22'

set :ssh_options, {:forward_agent => true}
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
server "192.168.1.104", :web, :app, :db, :primary => true
#role :web, "192.168.1.104"                          # Your HTTP server, Apache/etc
#role :app, "192.168.1.104"                          # This may be the same as your `Web` server
#role :db,  "192.168.1.104", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
