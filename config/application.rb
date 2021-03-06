# -*- encoding : utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Leihs
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    #
    config.i18n.enforce_available_locales = false
    # The *correct* way to do this is this:
    #config.i18n.enforce_available_locales = true
    #config.i18n.available_locales = [:de_CH, :en_GB, :en_US, :es, :gsw_CH]
    # But the Faker gem is currently broken and does not accept properly spelled locales like 'en_US', it tries
    # to look for 'en' and that breaks. If Faker is ever fixed, we can uncomment the above lines.

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.precompile += %w( application.js
                                    borrow.js
                                    manage.js
                                    application.css
                                    print.css
                                    i18n/locale/*
                                    simile_timeline/* 
                                    timeline.css
                                    upload.js
                                  )
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.active_record.whitelist_attributes = false
  end
end

########################################################################
#rails3#

######################################################
# This ensures that a mongrel can start even if it's started
# by a user that is not the same user the mongrel runs as. In other words,
# if user 'leihs' should run the mongrel but you use user 'root' to start,
# this would usually fail since that user can't write to /root/.ruby_inline.
# This temp dir takes care of that.

#temp = Tempfile.new('ruby_inline', '/tmp')
#dir = temp.path
#temp.delete
#Dir.mkdir(dir, 0755)
#ENV['INLINEDIR'] = dir

# Necessary to prevent this error:
# http://www.viget.com/extend/rubyinline-in-shared-rails-environments/
ENV['INLINEDIR'] = "#{Rails.root}/tmp/"

######################################################

PER_PAGE = 20

######################################################
