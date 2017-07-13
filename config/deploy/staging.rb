server 'staging.clubloot.com', user: 'deploy', roles: %w{web app db}
set :stage, :production
set :rails_env, :production
set :branch, current_git_branch
