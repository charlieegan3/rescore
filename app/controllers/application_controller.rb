class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :method_name

  def index
    @review_count = Statistic.find_by_identifier('review_count').value[:count]
    @movie_count = Movie.complete.size
    @movie = Movie.latest
  end

  def about
  end

  def current_user
    @current_user ||= User.find_by_id(cookies.permanent.signed[:user_id]) if cookies.permanent.signed[:user_id]
  end
end
