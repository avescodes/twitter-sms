#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do
  $running = false
end

twitter = TwitterSms.new(File.dirname(__FILE__) + "/../../config/twitter-sms")
while($running) do
  ActiveRecord::Base.logger.info "This daemon is still running at #{Time.now}.\n"
  twitter.run

  sleep 10 # Is this 10 sec. min. or hours?
end
