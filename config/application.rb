require_relative 'boot'

require "rails/rails"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Clubloot
  class Application < Rails::Application
  end
end
