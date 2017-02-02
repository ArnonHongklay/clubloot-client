source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'

# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'knock', '~> 2.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
gem 'mongoid', '~> 6.0.0'
gem 'mongoid-slug'
gem 'mongoid_rails_migrations'
gem 'mongoid-paperclip'
gem 'bson_ext'

gem 'devise'
gem 'omniauth-facebook'
gem 'figaro'
gem 'bulma-rails'
gem 'font-awesome-rails'
gem 'autoprefixer-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
gem 'redis-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rbenv', git: 'https://github.com/capistrano/rbenv.git'
  gem 'capistrano-rails-console'
  gem 'capistrano-npm'

  gem 'ffaker'

  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'master'
  end
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
