class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # Include SessionsHepler to help all pages can use session
  include SessionsHelper

	# Confirm a logged-in user
	private
	
	  def logged_in_user 
	    unless logged_in?
	      store_location
	      flash[:danger] = "Please log in."
	      redirect_to login_url
	    end
	  end
end
