require "test_helper"

class Public::BlockUsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_block_users_index_url
    assert_response :success
  end
end
