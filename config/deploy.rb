set :application, 'openmedia.bg'
set :repo_url, 'https://github.com/openmediabg/openmedia.bg.git'

set :branch, :master

set :deploy_to, "/home/openmedia/#{fetch(:application)}"

set :log_level, :info

set :linked_files, %w(.env web/.htaccess)
set :linked_dirs, %w(web/app/uploads)

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :service, :nginx, :reload
    end
  end
end
