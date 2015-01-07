source "https://rubygems.org"

rails_version = ENV['RAILS_VERSION'] || '>= 3.0'
gem 'rails', rails_version

gem 'jquery-rails'
gem 'jquery-ui-rails'

if defined?(JRUBY_VERSION)
  gem 'activerecord-jdbcsqlite3-adapter'
else
  gem 'sqlite3'
end

gemspec
