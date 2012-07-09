require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  test "should get accept" do
    get :accept
    assert_response :success
  end

  test "should get cancel" do
    get :cancel
    assert_response :success
  end

end
