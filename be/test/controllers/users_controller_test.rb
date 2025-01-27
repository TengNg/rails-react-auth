require "./test/test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    set_auth_cookies(user: @user)
  end

  test "should get current user" do
    get "/profile", as: :json
    assert_response :success
  end

  test "should get user by username" do
    get "/users/#{@user.username}", as: :json
    assert_response :success
  end

  test "should logout successfully" do
    user = users(:one)
    set_auth_cookies(user:)

    delete '/logout'
    assert_response :success
  end

  test "should perform logout of all devices successfully" do
    user = users(:one)
    username = user.username
    set_auth_cookies(user:)

    query = "User.find_by(username: '#{username}').refresh_token_version"
    assert_difference(query) do
      delete '/logout_of_all_devices'
    end

    assert_response :success
  end
end
