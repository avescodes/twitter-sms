require 'rubygems'
require 'twitter'
require 'tlsmail'

class Checker
  
  def initialize(user,bot,config)
    @user = user
    @bot = bot
    @config = config
    @config['wait'] *= 60 # specified in minutes, translate to seconds

    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
  end
  
  def run
    if @config['keep_alive']
      while true
        update
        Kernel.sleep @config['wait']
      end
    else
      update
    end
  end
  
  def update
    twitter = Twitter::Base.new(@user['name'],@user['password'])
    if twitter.rate_limit_status.remaining_hits > 0
      now = Time.now
    
      tweets = twitter.timeline(:friends, :since => now - @config['wait'])

      # kill old tweets
      tweets.reject! {|t| t.user.screen_name == @user['name']}
      tweets.reverse!
    
      puts tweets
      send tweets unless tweets.nil?
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
        puts "\tSent: #{tweet.user.screen_name}: #{tweet.text[0..20]}..."
      end
    end
    puts "Messages sent."
  end    
    
    
end

config = YAML.load_file(ENV['HOME'] + '/.twtbot.conf')
program = Checker.new(config['user'],config['bot'],config['config'])
program.run
