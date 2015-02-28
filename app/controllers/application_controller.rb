class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @review_count = Statistic.find_by_identifier('review_count').value[:count]
    @movie_count = Movie.complete_movies.length
    @movie = Movie.latest if Movie.latest.complete?
    @movie = Movie.first if !Movie.latest.complete?
  end

  def about
  end
end
