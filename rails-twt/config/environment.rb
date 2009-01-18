# Be sure to restart your server when you modify this file

RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  config.gem "neufelry-twitter-sms", :source => "http://gems.github.com"

  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_rails-twt_session',
    :secret      => 'dab7f0fd1c7e734aefc58795a4e525066a2c5b55adfedc013bd8f01a07d695e83ca9b1fda1ecce381f3c92dad86400a6e0f75aa123ef9bb77a30895652ba77ab'
  }
end
