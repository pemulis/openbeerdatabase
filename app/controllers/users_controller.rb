class UsersController < ApplicationController
  before_filter :authenticate, only: [:show]
  before_filter :find_user,    only: [:show]
  before_filter :authorize,    only: [:show]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user

      redirect_to user_url(@user)
    else
      render :new
    end
  end

  protected

  def authorize
    redirect_to(root_url) unless current_user == @user
  end

  def find_user
    @user = User.find(params[:id])
  end
end
