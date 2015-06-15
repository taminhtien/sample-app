class UsersController < ApplicationController
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
    else
      render 'edit'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
