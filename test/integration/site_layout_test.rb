require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
	def setup
		@user = users(:michael)
	end

 	test "layout links" do
  	get root_path
   	assert_template 'static_pages/home'
   	assert_select "a[href=?]", root_path, count: 2
   	assert_select "a[href=?]", about_path
   	assert_select "a[href=?]", contact_path
 	end

 	test "layout links for logged in user" do
 		log_in_as(@user)
   	get user_path(@user)
   	assert_template 'users/show'
   	assert_select "a[href=?]", root_path
   	assert_select "a[href=?]", users_path
   	assert_select "a[href=?]", user_path(@user)
   	assert_select "a[href=?]", edit_user_path(@user)
   	assert_select "a[href=?]", logout_path 
 	end

 	test "layout links for non-logged in user" do
   	get user_path(@user)
   	assert_template 'users/show'
   	assert_select "a[href=?]", root_path
   	assert_select "a[href=?]", users_path, count: 0
   	assert_select "a[href=?]", edit_user_path(@user), count: 0
   	assert_select "a[href=?]", logout_path, count: 0
   	assert_select "a[href=?]", users_path, count: 0
 	end
end
