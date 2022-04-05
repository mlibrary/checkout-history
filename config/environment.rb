# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!
Rails.logger.datetime_format = "%FT%T%:z"
