class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @review_count = 1337 #Movie.review_count - lets cache this sometime
    @movie_count = Movie.count
    @movie = Movie.latest if Movie.latest.complete?
    @movie = Movie.first if !Movie.latest.complete?
  end

  def about
  end
end
