module Authentication
  protected

  def self.included(base)
    if base.respond_to?(:helper_method)
      base.__send__(:helper_method, :current_user)
    end
  end

  def access_denied
    redirect_to root_url
  end

  def authenticate
    access_denied unless signed_in?
  end

  def current_user
    @current_user ||= (user_from_token || user_from_session || :false)
  end

  def current_user=(user)
    @current_user  = user.is_a?(User) ? user    : nil
    session[:user] = user.is_a?(User) ? user.id : nil
  end

  def signed_in?
    current_user != :false
  end

  def user_from_session
    self.current_user = User.find(session[:user]) if session[:user]
  end

  def user_from_token
    return unless params[:token].present?

    if request.get?
      User.find_by_token(params[:token])
    else
      User.find_by_private_token(params[:token])
    end
  end
end
