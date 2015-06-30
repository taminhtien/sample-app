require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:michael)
  end

  test "micropost interface" do
  	log_in_as(@user)
  	get root_path
  	assert_select 'div.pagination'
  	assert_select 'section.user_info'
  	assert_select 'section.micropost_form'
  	# Invalid submission
  	assert_no_difference 'Micropost.count' do
  		post microposts_path, micropost: { content: "" }
  	end
  	assert_select 'div#error_explanation'
  	# Valid submission
  	content = "This is valid content"
  	assert_difference 'Micropost.count', 1 do
  		post microposts_path, micropost: { content: content }
  	end
  	assert_redirected_to root_url
  	follow_redirect!
  	assert_match content, response.body
  	# Delete micropost
  	assert_select 'a', text: "delete"
  	first_micropost = @user.microposts.paginate(page: 1).first
  	assert_difference 'Micropost.count', -1 do
  		delete micropost_path(first_micropost)
  	end
  	# Visit a different user
  	get user_path(users(:archer))
  	assert_select 'a', text: "delete", count: 0
	end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero micropost
    other_user = users(:mallory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A test micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end
