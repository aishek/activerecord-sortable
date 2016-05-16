$:.push File.expand_path('../lib', __FILE__)

require 'activerecord/sortable/version'

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

  gem.add_development_dependency 'capybara'
  gem.add_development_dependency 'poltergeist', '1.7.0'
  gem.add_development_dependency 'phantomjs', '2.1.1.0'

  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'rubocop'
end
