module SessionsHelper
	# Logs in the given user
	def log_in(user)
		# session is a supported method by Rails
		# Put user.id into session
		session[:user_id] = user.id
	end

	# Returns the current logged-in user (if any).
	def current_user
		# Assigns user_id = session[:user_id]
		if (user_id = session[:user_id]) # If session[:user_id] exists
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id]) # If user exists in cookies
      # raise # Generate an exception, if test pass -> this branch is untested
			user = User.find_by(id: user_id) # Find user_id exists in database
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	# Returns true if the user is logged in and false otherwise
	# The purpose of this method is help view to render page properly
	def logged_in?
		!current_user.nil?
	end

	# Logs out the current user
	def log_out
    forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	# Remembers a user in a persistent session
	def remember(user)
		user.remember # Creates the token and save the digest into database
		 # permanent method will persist data for 20 years
		 # signed method will encrypt data because only cookies[] doesn't do that
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token # remember_token attribute
	end

  # Returns true if the given user is the current user
  def current_user?(user)
    user == current_user
  end

  # Forgets a persistent session
  def forget(user)
    user.forget # Update :remember_digest to nil
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Redirects to stored location or default
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.url if request.get? # Only GET request
  end
end
