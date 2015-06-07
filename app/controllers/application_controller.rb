class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :method_name

  def index
    @movie_count = Movie.complete.size
    @review_count = Statistic.find_by_identifier('review_count').value[:count]
    @aspects = Statistic.find_by_identifier('topic_sentiments').value
    @counts = Statistic.find_by_identifier('topic_counts').value
    @movies = Movie.complete.order('created_at DESC').limit(10).select(['id', 'title', 'slug', 'created_at'])
  end
end
