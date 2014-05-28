$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'activerecord/sortable/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = 'activerecord-sortable'
  gem.version     = ActiveRecord::Sortable::VERSION
  gem.authors     = ['Alexandr Borisov', 'Kirill Khrapkov']
  gem.email       = 'aishek@gmail.com'
  gem.summary     = 'activerecord-sortable allows you easily integrate jquery ui sortable with your models'
  gem.homepage  = 'https://github.com/aishek/activerecord-sortable'
  gem.licenses  = ['MIT']

  gem.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  gem.test_files = Dir["spec/**/*"]

  gem.add_runtime_dependency 'rails', '4.1.1'

  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'selenium-webdriver'
  gem.add_development_dependency 'coveralls'

  gem.add_development_dependency 'sqlite3'
end
