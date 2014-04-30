require 'simplecov'
SimpleCov.start 'rails' do
  merge_timeout 3600
end

require 'rubygems'
require 'pry'

# require 'simplecov'
# SimpleCov.start 'rails' do
#   merge_timeout 3600
# end

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require 'cucumber/rails'
require 'rack_session_access/capybara'

Capybara.javascript_driver = :selenium

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# screenshot
require 'capybara-screenshot/cucumber'
Capybara::Screenshot.autosave_on_failure = true

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how 
# your application behaves in the production environment, where an error page will 
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

begin
  # we cannot use transactional tests because we are restoring personas data from sql dumps
  our_default_strategy = :truncation
  DatabaseCleaner.strategy = our_default_strategy
  DatabaseCleaner.clean_with our_default_strategy
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Before do
  srand(ENV['TEST_RANDOM_SEED'].to_i)
  DatabaseCleaner.start
end

Before('@javascript') do
  page.driver.browser.manage.window.maximize # to prevent Selenium::WebDriver::Error::MoveTargetOutOfBoundsError: Element cannot be scrolled into view
end

After do |scenario|
  sleep(0.33) # to prevent lazy failures i.e: features/examples/benutzerverwaltung.feature:328 "Zugriff entfernen als Inventar-Verwalter"
  DatabaseCleaner.clean
end

if ENV["PRY"]
  AfterStep do
    binding.pry
  end
end

at_exit do
  s = "TEST_RANDOM_SEED=#{ENV['TEST_RANDOM_SEED']}"
  puts s
  Rails.logger.info s
end
