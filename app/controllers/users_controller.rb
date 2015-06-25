class UsersController < ApplicationController
  # The filter will act on edit and update actions
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # Detroys an user
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  # Sign up process
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
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
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # confirm the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
