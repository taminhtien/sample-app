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
  end

  test "valid sign up information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name:                   "Tien Ta",
                                            email:                  "tienta@gmail.com",
                                            password:               "tienta",
                                            password_confirmation:  "tienta" }
    end
    assert_template 'users/show'
  end
end
