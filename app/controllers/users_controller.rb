class UsersController < ApplicationController
  # The filter will act on edit and update actions
  before_action :logged_in_user, only: [:edit, :update]
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  # Sign up process
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # Log user in
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  # Action loads the user edit page
  def edit
    @user = User.find(params[:id])
  end

  # Updates user's info
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before update

    # Confirm a logged-in user
    def logged_in_user 
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
