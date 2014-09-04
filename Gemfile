source 'http://rubygems.org'

gem 'rails', '4.0.4'

gem 'active_hash', '~> 1.3'
gem 'activerecord-jdbcmysql-adapter', platform: :jruby
gem 'acts-as-dag', '~> 4.0' # alternative: 'dagnabit'
gem 'barby', '~> 0.5.0'
gem 'better_errors', group: :development
gem 'binding_of_caller', group: :development
gem 'capistrano', '2.15.5', group: :development
gem 'capistrano-ext', group: :development
gem 'capistrano-rbenv', '~> 1.0', group: :development

gem "jasminerice", git: 'https://github.com/bradphelan/jasminerice.git', group: [:test, :development] # needed for implement coffeescript, fixtures and asset pipeline serverd css into jasmine
gem "rack_session_access", "~> 0.1.1", group: :test
gem 'capybara', '~> 2.4', group: [:test, :development]
gem 'capybara-screenshot', group: [:test, :development]
gem 'chunky_png', '~> 1.2'
gem 'coffee-rails', '~> 4.0'
gem 'coffee-script', '~> 2.2'
gem 'compass-rails', '~> 1.1'
gem 'cucumber-rails', '~> 1.3', group: [:test, :development], require: false
gem 'database_cleaner', group: [:test, :development]
gem 'factory_girl', '~> 4.1', group: [:test, :development]
gem 'factory_girl_rails', '~> 4.1', group: [:test, :development]
gem 'faker', '1.3.0', group: [:test, :development] # NOTE '~> 1.4' doesn't work beacause "I18n::InvalidLocale" error, see note for config.i18n in config/application.rb
gem 'font-awesome-rails', '~> 3.2.1' # NOTE in order to upgrade to '~> 4.0', use .fa css class instead of .icon
gem 'foreigner', '~> 1.6'
gem 'geocoder', '~> 1.1'
gem 'gettext_i18n_rails', '~> 1.0'
gem 'guard-jasmine', '~> 1.19', group: [:test, :development]
gem 'haml', '~> 4.0'
gem 'haml_assets', '~> 0.2'
gem 'jquery-rails', '2.1.3' # '~> 2.1' FIXME the version 2.1.4 clashes with underscore-rails 1.4.2.1 + # NOTE in order to upgrate to '~> 3.1', first adapt the code removing the .live() functions
gem 'jquery-tmpl-rails', '~> 1.1'
gem 'jruby-openssl', platform: :jruby
gem 'json', '~> 1.8'
gem 'jsrender-rails', '~> 1.2', git: 'https://github.com/spape/jsrender-rails.git', branch: 'own_template_prefix'
gem 'ladle', group: :test
gem 'launchy', '~> 2.1', group: [:test, :development]
gem 'meta_request', group: :development
gem 'mini_magick', '~> 3.4'
gem 'mysql2', '~> 0.3.11', platform: :mri
gem 'net-ldap', require: 'net/ldap'
gem 'newrelic_rpm', '~> 3.5'
gem 'nilify_blanks', '~> 1.1'
gem 'paperclip', '~> 3.5' # NOTE in order to upgrate to '~> 4.0', first adapt the code to avoid the Paperclip::Errors::MissingRequiredValidatorError
gem 'phantomjs', '~> 1.9.7', group: [:test, :development] # headless webdriver (UI & JS tests)
gem 'protected_attributes', '~> 1.0'
gem 'pry', group: [:test, :development]
gem 'pry-byebug', group: [:test, :development]
gem 'pry-rails', group: [:test, :development]
gem 'rails_autolink', '~> 1.0'
gem 'rake' # So that cronjobs work -- otherwise they can't find rake
gem 'redcarpet', group: [:test, :development] # This isn't being pulled in by yard, but it's required
gem 'rgl', '~> 0.4.0', require: 'rgl/adjacency' # use ruby-graphviz instead ?? (already in test group)
gem 'rspec', '~> 3.0', group: [:test, :development], require: false
gem 'rspec-rails', '~> 3.0', group: [:test, :development], require: false
gem 'ruby_parser', '~> 3.1' # gettext dependency that Bundler seems unable to resolve
gem 'sass', '~> 3.2'
gem 'sass-rails', '~> 4.0'
gem 'selenium-webdriver', group: [:test, :development]
gem 'therubyracer', platform: :mri
gem 'therubyrhino', platform: :jruby
gem 'thin', group: :development, platform: :mri # web server (Webrick do not support keep-alive connections)
gem 'timecop', '~> 0.7', group: [:test, :development]
gem 'trinidad', group: :development, platform: :jruby # web server (Webrick do not support keep-alive connections)
gem 'uglifier', '~> 2.4'
gem 'underscore-rails', '~> 1.6'
gem 'will_paginate', '~> 3.0'
gem 'yard', group: [:test, :development]
