ENV['RAILS_ENV'] ||= 'test'

require 'activerecord/sortable'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = "random"
end
