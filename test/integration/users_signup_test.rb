require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid sign up information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {  name:                   "",
                                email:                  "user@invalid",
                                password:               "foo",
                                password_confirmation:  "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'

  end

  test "valid sign up information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:                   "Tien Ta1",
                                            email:                  "tienta1@gmail.com",
                                            password:               "tienta1",
                                            password_confirmation:  "tienta1" }
    end
    #assert_template 'users/show'
    #Passert_not flash.empty?
    # Assert is_logged_in return 1
    #assert is_logged_in?
  end
end
