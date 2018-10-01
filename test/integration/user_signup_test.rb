require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {
          name: "",
          email: "busko.bogdan@gmail",
          password: "foo",
          password_confirmation: "bar"
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
          name: "Bogdan",
          email: "busko.bogdan@gmail.com",
          password: "123456",
          password_confirmation: "123456"
        }
      }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
