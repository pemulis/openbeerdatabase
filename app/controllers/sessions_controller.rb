class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])

    if user.present?
      self.current_user = user

      redirect_to user
    else
      redirect_to new_session_url, :alert => "E-mail or password is incorrect. Please try again."
    end
  end
end
