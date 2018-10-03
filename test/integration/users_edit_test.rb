require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'unsuccessful edit' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
          name: '',
          email: 'jasjhdhkgasjd',
          password: '12asf',
          password_confirmation: 'bla'
        }
      }
    assert_template 'users/edit'
  end

  test 'successful edit' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: '',
        password_confirmation: ''
      }
    }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'shuold redirect edit if not logged in' do
    get edit_user_path @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'shuold redirect update if not logged in' do
    patch user_path(@user), params: { user: { name: 'Bogdan', email: 'busko.bogdan@gmail.com' } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
