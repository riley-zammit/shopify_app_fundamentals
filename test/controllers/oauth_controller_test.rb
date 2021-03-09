require 'test_helper'

class OauthControllerTest < ActionDispatch::IntegrationTest
  test "should get authenticate" do
    get oauth_authenticate_url
    assert_response :success
  end

end
