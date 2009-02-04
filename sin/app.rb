require 'rubygems'
require 'sinatra'

require 'twitter-sms'
require 'json'

configure do
  Twitter = TwitterSms::Checker.new
end

helpers do
  def twitter_link(person)
    haml "%a{ :href => \"http://www.twitter.com/#{person}\"} #{person} "
  end
end

before do
  @active = Twitter.config['active']
  @ignored = Twitter.config['no_follow']
  @twitter = Twitter
end

get '/*' do
  haml :index
end
