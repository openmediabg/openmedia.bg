set :stage, :production

server 'openmedia.bg', user: 'openmedia', roles: %w(web app db)

fetch(:default_env).merge!(wp_env: :production)
