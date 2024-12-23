source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.2.0"
# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"
# Use Puma as the app server
gem "puma", "~> 6.0"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"

# needed in production gems for the dev_seed task which is needed for loading up the testing namespace db.
gem "faker"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

gem "amazing_print"
gem "rails_semantic_logger"
gem "yabeda-rails"
gem "yabeda-puma-plugin"
gem "yabeda-prometheus"

gem "alma_rest_client",
  git: "https://github.com/mlibrary/alma_rest_client",
  tag: "1.3.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
  gem "simplecov"
  gem "standardrb"
end

group :test do
  gem "factory_bot_rails"
  gem "database_cleaner"
  gem "webmock"
end

group :development do
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
