# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "flat_bot"
set :repo_url, "git@github.com:drLoom/flat_bot.git"

# Default branch is :master
set :branch, 'main'
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/apps/flat_bot"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/master.key', 'tmp/anecs.txt'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "storage", 'tmp/god_pids'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app) do
      execute "cd #{current_path} && (~/.rvm/bin/rvm default do bundle exec pumactl -P #{current_path}/tmp/pids/server.pid restart)"
    end
  end

  desc 'Restart polling'
  task :restart_polling do
    on roles(:app) do
      execute "cd #{current_path} && (~/.rvm/bin/rvm default do bundle exec god stop)" rescue nil
      execute "cd #{current_path} && (~/.rvm/bin/rvm default do bundle exec god terminate)" rescue nil
      execute "cd #{current_path} && (~/.rvm/bin/rvm default do bundle exec god start -c lib/god/polling.god) > /dev/null 2>&1"
    end
  end

  desc 'Stop polling'
  task :stop_polling do
    on roles(:app) do
      execute "cd #{current_path} && (~/.rvm/bin/rvm default do bundle exec god stop tpooling)"
    end
  end
end

after 'deploy:publishing', 'deploy:restart'
after 'deploy:restart', 'deploy:restart_polling'
