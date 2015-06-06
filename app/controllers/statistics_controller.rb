class StatisticsController < ApplicationController
  def index
    return redirect_to :root if Movie.count == 0
    Statistic.refresh if Statistic.count == 0

    @review_count = Statistic.find_by_identifier('review_count').value[:count]
    @people_count = Statistic.find_by_identifier('people_count').value[:count]

    @aspects = Statistic.find_by_identifier('topic_sentiments').value
    @counts = Statistic.find_by_identifier('topic_counts').value

    @movies = Movie.complete.order('created_at DESC').limit(10).select(['id', 'title', 'slug', 'created_at'])
  end

  def refresh
    Statistic.refresh
    flash[:notice] = "Stats Updated"
    redirect_to :movie_admin
  end
end
