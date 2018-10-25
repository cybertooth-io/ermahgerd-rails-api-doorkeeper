# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'

# Use Puma as the app server
gem 'puma', '~> 3.11'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'jwt_sessions', '~> 2.2.1'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# /health_check controller that can be used by a balancer to determine if the app is running
gem 'health_check', '~> 3.0'

# seed-fu for better seeding practices
gem 'seed-fu', '~> 2.3'

# Authorization
gem 'jsonapi-authorization', '~> 1.0.0.beta2'

gem 'jsonapi-resources', '~> 0.9'

# strip whitespace from our model fields (see https://github.com/holli/auto_strip_attributes)
gem 'auto_strip_attributes', '~> 2.5'

# rails migration support for database views
gem 'scenic', '~> 1.4'

# paperclip for handling file uploads and pushing to S3
gem 'paperclip', '~> 6.1'

# add the aws-sdk for storing images in S3
gem 'aws-sdk', '~> 3.0'

# Use postgres database
gem 'pg', '~> 1.1'

# browser helps collect information about browser requests
gem 'browser'

# Sidekiq jobs
gem 'sidekiq', '~> 5.2'

# Strong Passwords if you want (https://github.com/bdmac/strong_password)
# gem 'strong_password', '~> 0.0.6'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'better_errors', '~> 2.5'
  gem 'letter_opener', '~> 1.6'
  gem 'rubocop', require: false
end

group :test do
  gem 'timecop', '~> 0.9'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
