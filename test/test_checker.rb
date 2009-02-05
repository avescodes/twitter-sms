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
        @checker = TwitterSms::Checker.new("#{dir}/example.conf")
      end

      should "have loaded a config properly" do
        assert(@checker.config)
        assert_equal @checker.username, "twtbot"
      end

    end
  end
end
