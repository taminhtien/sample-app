module SessionsHelper
	# Logs in the given user
	def log_in(user)
		# session is a supported method by Rails
		session[:user_id] = user.id
	end
end
