ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def rtoken_cookie_name
      "#{ENV['REFRESH_TOKEN_COOKIE_PREFIX'] or ''}_rtoken"
    end

    def atoken_cookie_name
      "#{ENV['ACCESS_TOKEN_COOKIE_PREFIX'] or ''}_atoken"
    end

    def set_auth_cookies(user:)
      payload = {
        user_data: {
          id: user.id,
          username: user.username,
          refresh_token_version: user.refresh_token_version,
        }
      }
      @token = JWT.encode(payload, ENV['ACCESS_TOKEN_SECRET'], 'HS256')
      cookies[atoken_cookie_name] = @token
      user
    end
  end
end
