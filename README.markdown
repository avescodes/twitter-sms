twitter-sms: Twitter SMS for the rest of us.
=======================================

Twitter-sms bridges the gap left by Twitter.com when it removed SMS capability for many countries. Twitter-sms runs in the background and periodically checks Twitter for new tweets; When new tweets are found they are forwarded via a gmail account to your mobile phone's email address. 

All it requires is a 
* A running computer with internet access and Ruby installed. (*nix systems only for the moment.)
* google email address (to forward messages from)
* An SMS capable phone with an email-to-sms email address. (i.e. 12345551234@text.provider.net that automatically forwards messages to your phone as SMS)

DISCLAIMER: Please bear in mind that it MAY cost you to receive text message on your email address; I am not responsable for any costs incurred to you using this program.

Setup
-----
To use twitter-sms you will need only to create the config file "~/.twitter-sms.conf" and fill it with the necessary YAML mappings.

Here is an example conf:

    bot:
      email: "twitter.bot@gmail.com"
      password: p0n33zR0oL
    user:
      name: rkneufeld
      password: p0n33zR0oL
      phone: "12045555555@text.provider.net"
    config:
      per_hour: 12
      keep_alive: true

This config will cause the script to run forever; sending you the last 5 minutes tweets every 5 minutes. (60 / 5 == 12)

One can also run the script as a cron job; instructions to follow soon...
