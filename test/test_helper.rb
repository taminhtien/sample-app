ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
  	!session[:user_id].nil?
  end

  def log_in_as(user, options = {})
  	# 'password' will be default if the options[:password] is nil
  	password = options[:password] || 'password'
  	# Respectively with options[:remember_me]
  	remember_me = options[:remember_me] || '1'
  	if integration_test?
  		post login_path, session: { email: user.email, password: password, remember_me: remember_me }
  	else
  		session[:user_id] = user.id
  	end
  end

  private

  	# Returns true inside an integration test
  	# The purpose of this method is indicate
  	# whether the kind of test is integration test or not
  	def integration_test?
  		# The integration test consists post_via_redirect method
  		defined?(post_via_redirect)
  	end
end
