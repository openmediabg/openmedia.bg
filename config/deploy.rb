set :application, 'openmedia.bg'
set :repo_url, 'https://github.com/openmediabg/openmedia.bg.git'
set :branch, :master
set :deploy_to, "/home/openmedia/#{fetch(:application)}"
set :log_level, :info
set :keep_releases, 15
set :linked_files, %w(.env web/.htaccess)
set :linked_dirs, %w(web/app/uploads backups)

namespace :deploy do
  desc 'Keep folders which plugins persist their files in symlinked under shared/'
  task :symlink_plugin_persistant_folders do
    folders = %w(web/app/plugins/revslider/rs-plugin/css)

    on roles(:app) do
      folders.each do |folder_to_persist|
        unless test "[[ -d #{shared_path.join(folder_to_persist)} ]] "
          execute :cp, '-r', release_path.join(folder_to_persist), shared_path.join(folder_to_persist)
        end

        execute :rm, '-rf', release_path.join(folder_to_persist)
        execute :ln, '-s', shared_path.join(folder_to_persist), release_path.join(folder_to_persist)
      end
    end
  end

  before 'deploy:updated', 'deploy:symlink_plugin_persistant_folders'

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :service, :nginx, :reload
    end
  end
end
