require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AppWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #
    config.time_zone = "Brasilia"

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    config.middleware.use Rack::Attack

    # Skip views, helpers and assets when generating a new resource.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}')]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '**', '*.{rb,yml}')]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '**', '**', '*.{rb,yml}')]

    config.i18n.enforce_available_locales = false
    config.i18n.available_locales = [:"pt-BR"]
    config.i18n.default_locale = :"pt-BR"
    config.i18n.locale = :"pt-BR"

    # Encoding
    config.encoding = "utf-8"

    #Errors
    config.exceptions_app = self.routes

  end
end
