class PasswordResetsController < ApplicationController
	before_action :get_user, only: [:edit, :update]
	before_action :valid_user, only: [:edit, :update]
	before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
  end

  def create
  	@user = User.find_by(email: params[:password_reset][:email].downcase)
  	if @user
  		@user.create_reset_digest
  		@user.send_password_reset_email
  		flash[:info] = "Email send with password reset instructions"
  		redirect_to root_url
  	else
  		flash.now[:danger] = "Email address not found"
  		render 'new'
  	end
  end

  def update
  	if params[:user][:password].empty?
  		flash[:danger] = "Password can't be empty"
  		render 'edit'
  	elsif @user.update_attributes(user_params)
  		log_in @user # Puts user into session
  		flash[:success] = "Password has been reset"
  		redirect_to @user
  	else
  		render 'edit'
  	end
  end

  private

  	def get_user
  		@user = User.find_by(email: params[:email])	
  	end

  	# Confirms a valid user
  	def valid_user
  		unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
  			redirect_to root_url
  		end
  	end
  	
  	def user_params
  		params.require(:user).permit(:password, :password_confirmation)
  	end
end
