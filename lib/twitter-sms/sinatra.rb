require 'rubygems'
require 'sinatra'

require 'twitter-sms'
require 'json'

twitter_sms = TwitterSms::Checker.new

get '/' do
  twitter_sms.config.to_json
end
