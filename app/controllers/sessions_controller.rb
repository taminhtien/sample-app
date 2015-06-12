class SessionsController < ApplicationController
  def new
  end
  def create
  	# find_by method is supported by Active Record
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		# Log user in and redirect to user's show page
  		log_in user
  		# Rails automatically converts it to the route for user's page user_url(user)
  		redirect_to user
  	else
  		# Show errors
  		# :danger like a flag, which marks the danger message, display with red block.
  		#  It's supported by Bootstrap
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end
  def destroy
  end
end
