require_relative 'boot'

require "rails/all"
require 'rspotify'

Bundler.require(*Rails.groups)

module SpotifyBdayApi
  class Application < Rails::Application
    RSpotify::authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
    config.load_defaults 5.2
    config.api_only = true

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: %w(Authorization),
          methods: :any,
          expose: %w(Authorization),
          max_age: 600
      end
    end

  end
end
