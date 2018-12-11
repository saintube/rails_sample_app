require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "汽车在线论坛"
    assert_equal full_title("帮助"), "帮助 | 汽车在线论坛"
  end
end
