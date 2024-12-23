require_relative "boot"

require "rails/all"
require "csv"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CirculationHistory
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.autoload_paths << Rails.root.join("lib")
    config.rails_semantic_logger.started = true
    config.rails_semantic_logger.processing = true
    config.rails_semantic_logger.rendered = true
    config.colorize_logging = false
    config.time_zone = "Eastern Time (US & Canada)"
    Yabeda.configure do
      gauge :checkout_history_load_last_success, comment: "Time that the circ history load last succeeded"
      gauge :checkout_history_num_items_loaded, comment: "Number of items loaded into the checkout history database"
    end
  end
end
