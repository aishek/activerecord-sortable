source 'https://rubygems.org'

rails_version = ENV['RAILS_VERSION'] || '>= 3.0'
gem 'rails', rails_version

gem 'jquery-rails'
gem 'jquery-ui-rails'

if defined?(JRUBY_VERSION)
  gem 'activerecord-jdbcsqlite3-adapter'
else
  gem 'sqlite3'

  if defined?(RUBY_VERSION) && RUBY_VERSION == '2.2.0' && ['~> 3.2.0', '~> 4.0.0'].include?(ENV['RAILS_VERSION'])
    gem 'rubysl-test-unit'
  end
end

if defined?(RUBY_VERSION) && RUBY_VERSION == '2.2.0' && ENV['RAILS_VERSION'] == '~> 3.2.0'
  gem 'rspec-rails', github: 'rspec/rspec-rails', ref: 'a09a6231ceecefa177ec08b27c3066d5947e5899'
  gem 'rspec-support', github: 'rspec/rspec-support'
  gem 'rspec-core', github: 'rspec/rspec-core'
  gem 'rspec-expectations', github: 'rspec/rspec-expectations'
  gem 'rspec-mocks', github: 'rspec/rspec-mocks'
else
  gem 'rspec-rails'
end

gemspec
