class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  protected

  def current_user
    @current_user ||= User.where(_id: session[:user_id]).first
  end

  def validate_user
    unless current_user
      session[:original_request] = request.url
      redirect_to login_path
    end
  end
end
