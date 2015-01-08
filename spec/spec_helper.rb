ENV['RAILS_ENV'] ||= 'test'

require 'dummy_rails_app'

require 'rspec/rails'
require 'activerecord/sortable'

require 'coveralls'
Coveralls.wear!

require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.app = Dummy::Application

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = "random"
end
