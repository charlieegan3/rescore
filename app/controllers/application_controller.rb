class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @review_count = Movie.review_count
    @movie_count = Movie.all.size
    @movie = Movie.last
  end

  def about
  end
end
