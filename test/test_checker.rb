require File.dirname(__FILE__) + '/test_helper'

class CheckerTest < Test::Unit::TestCase
  context "Checker" do

    context "space stripper class method" do
      should "strip... space" do
        str = "test\n \t\ntest"
        correct_str = "test\n\ntest"
        TwitterSms::space_stripper!(str)
        assert_equal(str,correct_str)
      end
    end

    context "instance" do
      setup do
        dir = `pwd`.chomp.gsub(/test\/$/,"")
        @checker = TwitterSms::Checker.new("#{dir}/test/test.conf")
      end

      should "have loaded a config properly" do
        assert(@checker.config)
        assert_equal @checker.username, "twt_bot"
      end

      # How to do without giving away password?
      # should "return an array of tweets when updating (what about internet down?)

      context "handling tweets" do
        setup do
          dir = `pwd`.chomp.gsub(/test\/$/,"")
        # Pull in marshalled tweets
        end

        # should "reduce two tweets to one when ignoring user"
        # should "reduce two tweets to one when not following self"
        # should "reverse order of tweets"
      end
      # Not sure how to test run as a whole, going to test individual parts
        # Gotta remember not to test the gems i'm using but just how i deal with data!
    end
  end
end
