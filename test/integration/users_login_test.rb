require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:tien)
  end

  # This test is in order to control the emergence of the flash
  test "login with invalid information" do
  	# Visit login path
  	get login_path
  	# Verify that the new session renders properly
  	assert_template 'sessions/new'
	# Post to login path invalid params hash
  	post login_path, session: { email: "", password: "" }
  	# Verify that the new session gets re-render...
  	assert_template 'sessions/new'
  	# and the flash appears
  	assert_not flash.empty?
  	# Visit home page
  	get root_path
  	# Verify the flash doesn't appear
  	assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'taminhtien1993@@' }
    # Check right redirect target
    assert_redirected_to @user
    # Actually visit target page
    follow_redirect!
    assert_template 'users/show'
    # Verifies the login link disappears
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'taminhtien1993@@' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,       count: 0
    assert_select "a[href=?]", user_path(@user),  count: 0
  end

end