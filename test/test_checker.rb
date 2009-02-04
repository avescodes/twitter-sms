require File.dirname(__FILE__) + '/test_helper'

class CheckerTest < Test::Unit::TestCase
  def test_truth
    assert(true)
  end

  def test_space_stripper_removes_space
    str = <<EOS
The line below has just one space

The line above has just one space
EOS
    correct_str = <<EOS
The line below has just one space

The line above has just one space
EOS
    TwitterSms::space_stripper!(str)
    assert_equal(str,correct_str)
  end

end
