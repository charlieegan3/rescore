class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    cookies.permanent.signed[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in!"
  end

  def failure
    flash[:alert] = "Login failed or was cancelled"
    redirect_to root_url
  end

  def destroy
    cookies[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
