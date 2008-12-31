#!/opt/local/bin/ruby
require 'rubygems'
require 'twitter'
require 'tlsmail'

SEC_PER_HOUR = 3600 # Seconds per hour
FUZZ = 5 # Fuzz for ":since => now - ..."; makes sure we don't miss the odd twit

class TwitterSms

  def initialize(config_file="#{ENV['HOME'] + '/.twitter-sms.conf'}")
    load_config(config_file)

    # Required for gmail smtp (and not a part of standalone Net::SMTP)
    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
  end

  def run
    if @config['keep_alive']
      while @config['keep_alive']
        load_config if config_stale?
        tweets = update
        send tweets unless tweets.nil?
        Kernel.sleep @config['wait']
      end
    else
      tweets = update
      send tweets unless tweets.nil?
    end
  end

  # Collect a list of recent tweets on a user's timeline (that are not their own)
  def update
    twitter = Twitter::Base.new(@user['name'],@user['password'])
    if twitter.rate_limit_status.remaining_hits > 0
      now = Time.now

      tweets = twitter.timeline(:friends, :since => now - @config['wait'] - FUZZ)

      tweets.reject! {|t| t.user.screen_name == @user['name']} unless @config['own_tweets']
      tweets.reverse! # Put things in right order
    else
      puts "Your account has run out of API calls; call not made."
    end
  end

  def send(tweets)
    puts "Sending received tweets..."
    Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', @bot['email'], "tweeterbot", :login) do |smtp|
      tweets.each do |tweet|
        content =
<<-EOF
From: #{@bot['email']}
To: #{@user['phone']}
Date: #{Time.parse(tweet.created_at).rfc2822}

#{tweet.user.screen_name}: #{tweet.text}
EOF
        smtp.send_message(content,@bot['email'],@user['phone'])
        puts "\tSent: #{tweet.user.screen_name}: #{tweet.text[0..20]}..."
      end
    end
    puts "Messages sent."
  end

  def load_config(config_file=@config_file['name'])
    # Load config file -- Add try block here
    config = YAML.load_file(config_file)
    @config_file = { 'name' => config_file,
              'modified_at' => File.mtime(config_file) }


    # Seperate config hashes into easier to use parts
    @user = config['user']
    @bot = config['bot']
    @config = config['config']

    @config['wait'] = SEC_PER_HOUR / @config['per_hour'] # translate to seconds and store
    @config['own_tweets'] ||= false
  end

  private

  def config_stale?
    return File.mtime(@config_file['name']) > @config_file['modified_at']
  end


end

# Add some logic for command line options
program = TwitterSms.new()
program.run
