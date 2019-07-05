require 'test_helper'

class AccessRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get access_requests_new_url
    assert_response :success
  end

  test "should get create" do
    get access_requests_create_url
    assert_response :success
  end

end
