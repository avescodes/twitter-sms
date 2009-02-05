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

      should "set wait time in seconds properly" do
        per_hour = @checker.config['per_hour']
        assert_equal( @checker.config['wait'], 3600/per_hour )
      end

      # should "return an array of tweets when updating (what about internet down?)
      # should "be able to send a fake message and receive it"

      context "handling tweets" do
        # should "reduce two tweets to one when ignoring user"
        # should "reduce two tweets to one when not following self"
        # should "reverse order of tweets"
      end
    end
  end
end
