require "./test/test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  test "should register successfully" do
    assert_difference("User.count") do
      post '/auth/register', params: register_params, as: :json
    end

    assert_response :created
  end

  test "should login successfully" do
    post '/auth/login', params: login_params, as: :json
    assert_response :success
  end

  private

  def register_params
    {
      auth: {
        username: 'testing',
        password: 'abcd1234',
      }
    }
  end

  def login_params
    {
      auth: {
        username: 'john_doe',
        password: 'abcd1234',
      }
    }
  end
end
