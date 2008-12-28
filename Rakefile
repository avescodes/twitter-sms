task :default => [:config]

task :config do
  config = YAML.load_file(ENV['HOME'] + '/.twtbot.conf')
  skip_by = 60 / config['config']['per_hour']
  puts "Please add the following to your cron jobs on your own or via 'crontab -e' "
  puts "*/#{skip_by} * * * * #{ENV['USER']} #{ENV['PWD']+'/twtbot.rb'}"
end
