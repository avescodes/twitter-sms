#!/opt/local/bin/ruby
require 'rubygems'
require 'twitter'
require 'tlsmail'
require 'optparse'

SEC_PER_HOUR = 3600 # Seconds per hour
FUZZ = 5 # Fuzz for ":since => now - ..."; makes sure we don't miss the odd twit

class TwitterSms

  def initialize(config_file="#{ENV['HOME'] + '/.twitter-sms.conf'}", args=ARGV)
    load_config(config_file)
    load_opts(args)

    # Required for gmail smtp (and not a part of standalone Net::SMTP)
    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
  end

  # Run the twitter-sms bot once or repeatedly, depending on config
  def run
    begin # do-while
      load_config if config_stale?

      tweets = update
      send tweets unless tweets.nil?



      if @config['keep_alive']
        puts "Waiting for #{@config['wait']/60.0} minutes..."
        Kernel.sleep @config['wait']
      end
    end while @config['keep_alive']
  end

  # Collect a list of recent tweets on a user's timeline (that are not their own)
  def update
    twitter = Twitter::Base.new(@user['name'],@user['password'])
    begin
      if twitter.rate_limit_status.remaining_hits > 0
        # For :since the 'FUZZ' is a few seconds used to try and keep missing seconds from
        # cropping up. Consequently it may send duplicate messages

        tweets = twitter.timeline(:friends, :since => Time.now - @config['wait'] - FUZZ)
        # Block own tweets if specified via settings
        tweets.reject! {|t| t.user.screen_name == @user['name']} unless @config['own_tweets']
        tweets.reverse! # reverse-chronological
      else
        puts "Your account has run out of API calls; call not made."
      end
    rescue
      puts "Error occured retreiving timeline. Perhaps Internet is down?"
    end
  end

  # Email via Gmail SMTP any tweets to the desired cell phone
  def send(tweets)
    puts "Sending received tweets..."
    begin
      Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', @bot['email'], "tweeterbot", :login) do |smtp|
        tweets.each do |tweet|
          smtp.send_message(content(tweet),@bot['email'],@user['phone']) rescue puts "Error occured sending message:"
          puts "\tSent: #{tweet.user.screen_name}: #{tweet.text[0..20]}..."
        end
      end
      puts "Messages sent."
    rescue
      puts "Error occured starting smtp. Perhaps account info is incorrect or Internet is down?"
    end
  end

  # Parse and store a config file (either as an initial load or as an update)
  def load_config(config_file=@config_file['name'])
    # Load config file -- Add try block here
    config = YAML.load_file(config_file)
    @config_file = { 'name' => config_file,
              'modified_at' => File.mtime(config_file) }


    # Seperate config hashes into easier to use parts
    @user = config['user']
    @bot = config['bot']
    # Merge specified config onto defaults
    @config = { 'own_tweets' => false,
                'keep_alive' => true,
                  'per_hour' => 60}.merge(config['config'])

    set_wait
  end

  private

  # Set wait time based on times per hour
  def set_wait
    @config['wait'] = SEC_PER_HOUR / @config['per_hour']
  end

  def load_opts(args)
    opts = OptionParser.new do |opts|
      opts.banner = "Twitter-sms bot help menu:\n"
      opts.banner += "==========================\n"
      opts.banner += "Usage #$0 [options]"

      opts.on('-t', '--times-per-hour [TIMES]',
              'Indicate the amount of times per hour to check (0 < TIMES <= 100)') do |times|
        times = 100 if times > 100
        times = 1 if times < 1 # once per hour minimum?
        @config['per_hour'] = times
      end

      opts.on('-o', '--own-tweets',
              "Makes your own tweets send in addition to followed account\'s tweets") do
        @config['own_tweets'] = true
      end

      opts.on('-s', '--single-check',
              'Forces the program to only check once, instead of continually') do
        @config['keep_alive'] = false
      end

      opts.on_tail('-h', '--help', 'display this help and exit') do
        puts opts
        exit
      end
    end

    opts.parse!(args)
  end

  def config_stale?
    return File.mtime(@config_file['name']) > @config_file['modified_at']
  end

  def content(tweet)
    "From: #{@bot['email']}\n"+
    "To: #{@user['phone']}\n"+
    "Date: #{Time.parse(tweet.created_at).rfc2822}\n\n"+
    "#{tweet.user.screen_name}: #{tweet.text}"
  end

end

# Run as program only if library is the running program
if $0 == __FILE__
  # Add some logic for command line options
  program = TwitterSms.new
  program.run
end
