require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    payload = { username: @user.username }
    @token = JWT.encode(payload, ENV['ACCESS_TOKEN_SECRET'], 'HS256')
    cookies[atoken_cookie_name] = @token
  end

  test "should get current user" do
    get "/profile", as: :json
    assert_response :success
  end

  test "should get user by username" do
    get "/users/#{@user.username}", as: :json
    assert_response :success
  end
end
