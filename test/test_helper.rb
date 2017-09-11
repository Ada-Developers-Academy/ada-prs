ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'

# Uncomment these lines to automatically start pry
# when a test fails or an exception is unhandled.
#require 'pry-rescue/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Use OmniAuth's mock responses
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new({
    provider: 'github',
    uid: 123456,
  })

  def self.auth_mock(name, login)
    {
      info: {
        name: name
      },
      extra: {
        raw_info: {
          login: login
        }
      },
      credentials: {
        token: '7ca3303893156b8c45185b61d0fc8ec3153ee33f',
        expires: false
      }
    }
  end

  AUTH_MOCKS = {
    github: auth_mock('Test User', 'adatest'),
    uninvited: auth_mock('Uninvited User', 'adauninvited'),
    invited_instructor: auth_mock('Invited Instructor', 'adainstructor'),
    invited_student: auth_mock('Invited Student', 'adastudent')
  }

  AUTH_MOCKS.each do |provider, auth_hash|
    OmniAuth.config.send(:add_mock, provider, auth_hash)
  end
end
