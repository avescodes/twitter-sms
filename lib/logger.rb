require 'fileutils'
module TwitterSms
  class Logger
    def initialize(filename,log_size=5)
      @log_size=log_size
      @raw_filename = filename
      @file = File.new(filename, "a") # 2x check mode

      write_intro
    end

    def log(message)
      @file.puts("#{Time.now.strftime("(%b %d - %H:%M:%S)")} #{message}")

      if `du -sm #{@raw_filename}`.split[0].to_i > @log_size #mb
        remake_file
      end
    end

    private

    def write_intro
      str = "Twitter-sms log file of messages since #{Time.now}"
      @file.puts(str)
    end

    def remake_file
      FileUtils.rm @raw_filename
      initialize
    end
  end
end
