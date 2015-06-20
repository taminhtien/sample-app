class SessionsController < ApplicationController
  def new
  end

  # Login
  def create
  	# find_by method is supported by Active Record
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
  		  # Log user in and redirect to user's show page
  		  log_in @user
        # remember user if checkbox is 1 and otherwise
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
  		  # Rails automatically converts it to the route for user's page user_url(user)
  		  redirect_back_or @user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
  	else
  		# Show errors
  		# :danger like a flag, which marks the danger message, display with red block.
  		#  It's supported by Bootstrap
  		flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end
  # Action controlls log out
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
