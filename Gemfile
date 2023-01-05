source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"
gem "rails", "~> 7.0.4", ">= 7.0.4"
gem "sprockets-rails"
gem "pg"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", "~> 4.0"
gem 'tty-logger'
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'faraday', require: false
gem 'nokogiri', require: false
gem 'sd_notify'
gem 'ed25519'
gem 'bcrypt_pbkdf'
gem 'god'
gem 'timeout', '~> 0.1.1'
gem 'sassc-rails'
gem 'bootstrap', '~> 5.2.2'
gem 'xxhash'
gem 'devise'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem "capistrano", require: false
  gem "capistrano-rails", require: false
  gem 'capistrano3-puma' , require: false
  gem 'capistrano-rvm', require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem 'database_cleaner-active_record'
  gem 'simplecov', require: false
  gem 'rails-controller-testing'
end
