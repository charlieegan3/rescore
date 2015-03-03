module ApplicationHelper
  def current_user
    @current_user ||= User.find_by_id(cookies.permanent.signed[:user_id]) if cookies.permanent.signed[:user_id]
  end
end
