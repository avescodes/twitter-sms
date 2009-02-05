require 'rubygems'
require 'sinatra'

require 'twitter-sms'
require 'json'

configure do
  TwtSms_Instance = TwitterSms::Checker.new
end

helpers do
  def twitter_link(person)
    haml "%a{ :href => \"http://www.twitter.com/#{person}\"} #{person} "
  end
end

before do
  @active = TwtSms_Instance.config['active']
  @ignored = TwtSms_Instance.config['no_follow']
  @twitter = TwtSms_Instance
end

get '/*' do
  haml :index
end
