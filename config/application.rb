require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module RateLimitTutorialRails
  class Application < Rails::Application
    config.load_defaults 7.0
    config.middleware.use Rack::Attack
  end
end
