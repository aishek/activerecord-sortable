require 'rails/version'

version = Rails::VERSION::STRING

# Construct possible paths for config/environment.rb in dummy-X.X.X,
# dummy-X.X, dummy-X
version_parts = version.split('.')
environment_paths = version_parts.length.downto(1).map do |count|
  version_part = version_parts.take(count).join('.')
  File.expand_path("../dummy-#{version_part}/config/environment.rb", __FILE__)
end

app_path = "spec/dummy-#{version_parts.take(2).join('.')}"

# Require environment if any dummy app exists, otherwise abort with instructions
if (environment_path = environment_paths.find(&File.method(:exist?)))
  require environment_path

  ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

  schema_path = "#{app_path}/db/schema.rb"
  load(schema_path)

  require 'activerecord_shared_db_connection_patch'
else

  rails_command = "rails new #{app_path} -TSJ --skip-bundle"
  command = "RAILS_VERSION=#{version} bundle exec #{rails_command}"

  abort [
    "No dummy app for rails #{version}",
    "Create using `#{command}`",
    'Tried:', *environment_paths
  ].join("\n")
end
