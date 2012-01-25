class SessionsController < ApplicationController
  def callback
    @auth = auth_hash

    user = User.find_or_initialize_by(email: @auth[:info][:email])

    unless user.persisted?
      user.name = @auth[:info][:name]
      user.save!
    end

    session[:user_id] = user.id

    redirect_to root_url, notice: "You have been logged in"
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "You have been logged out"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
