class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def following
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follower'
  end

  def index
  	@users = User.all
  	@book = Book.new
  end

  def search
    @book = Book.new
    @users = User.search(params[:model],params[:search_method],params[:search])
  end


  def show
  	@user = User.find(params[:id])
  	@book = Book.new
    @favorites = Favorite.where(user_id: @user.id)
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
  	  redirect_to user_path(@user.id)
    else
      flash[:notice] = "error"
      render :edit
    end
  end

  private

  def user_params
  	params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def correct_user
    if current_user.id != params[:id].to_i
      redirect_to user_path(current_user)
    end
  end
end
