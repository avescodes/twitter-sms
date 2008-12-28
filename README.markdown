twtbot: Twitter SMS for the rest of us.
=======================================

As many of you are probably aware Twitter recently discontinued SMS service to many Countries, mine included.

Fortunately there exist ways to get around this, by running your own SMS bot. I created twtbot as a simple SMS bot for people in my situation:
* SMS service with email address tied to account. i.e. email to "1204555555@text.provider.net" sends an SMS message to your phone
* Server or Home PC to run the script either continually or as a cron job
* Gmail account to send messages from (your own or a bot account)

If you fit this description then twtbot may be just the thing for you. Bear in mind it MAY cost you to receive text message on your email address; I am not responsable for any consts incurred to you using this script.

Setup
-----
To use twtbot you will need only to create the config file "~/.twtbot.conf" and fill it with the necessary YAML mappings.

Here is an example conf:

    bot:
      email: "twitter.bot@gmail.com"
      password: p0n33zR0oL
    user:
      name: "rkneufeld"
      password: p0n33zR0oL
      phone: 12045555555@text.provider.net
    config:
      per_hour: 12
      keep_alive: true

This config will cause the script to run forever; sending you the last 5 minutes tweets every 5 minutes. (60 / 5 == 12)

One can also run the script as a cron job; instructions to follow soon...
