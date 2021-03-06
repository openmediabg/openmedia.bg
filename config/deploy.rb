set :application, 'openmedia.bg'
set :repo_url, 'https://github.com/openmediabg/openmedia.bg.git'
set :branch, :master
set :deploy_to, "/home/openmedia/#{fetch(:application)}"
set :log_level, :info
set :keep_releases, 15
set :linked_files, %w(.env web/.htaccess)
set :linked_dirs, %w(web/app/uploads backups)
set :wpcli_custom_paths_to_sync, %w()
set :wpcli_remote_url, "openmedia.bg"
set :wpcli_local_url, "openmedia.dev"

namespace :deploy do
  desc 'Keep folders which plugins persist their files in symlinked under shared/'
  task :symlink_plugin_persistant_folders do
    folders = %w(web/app/plugins/revslider/rs-plugin/css)

    on roles(:app) do
      folders.each do |folder_to_persist|
        next unless test "[[ -d #{release_path.join(folder_to_persist)} ]]"

        unless test "[[ -d #{shared_path.join(folder_to_persist)} ]] "
          execute :cp, '-r', release_path.join(folder_to_persist), shared_path.join(folder_to_persist)
        end

        execute :rm, '-rf', release_path.join(folder_to_persist)
        execute :ln, '-s', shared_path.join(folder_to_persist), release_path.join(folder_to_persist)
      end
    end
  end

  desc 'Update WordPress template root paths to point to the new release'
  task :update_option_paths do
    on roles(:app) do
      within fetch(:release_path) do
        if test :wp, :core, 'is-installed'
          [:stylesheet_root, :template_root].each do |option|
            # Only change the value if it's an absolute path
            # i.e. The relative path "/themes" must remain unchanged
            # Also, the option might not be set, in which case we leave it like that
            value = capture :wp, :option, :get, option, raise_on_non_zero_exit: false
            if value != '' && value != '/themes'
              execute :wp, :option, :set, option, fetch(:release_path).join('web/wp/wp-content/themes')
            end
          end
        end
      end
    end
  end
end

# Note that you need to have WP-CLI installed on your server
# Uncomment the following line to run it on deploys if needed
after 'deploy:publishing', 'deploy:update_option_paths'
before 'deploy:updated', 'deploy:symlink_plugin_persistant_folders'
