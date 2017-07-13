source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'railsless-deploy'
gem 'capistrano', '~> 3.1'
gem 'capistrano-rails', '~> 1.1'
gem 'capistrano-rails-console'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rbenv', git: 'https://github.com/capistrano/rbenv.git'
gem 'capistrano-npm'
