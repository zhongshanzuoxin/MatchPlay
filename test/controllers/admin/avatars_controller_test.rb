require "test_helper"

class Admin::AvatarsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_avatars_index_url
    assert_response :success
  end
end
