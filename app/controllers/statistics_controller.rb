class StatisticsController < ApplicationController
  def index
    Statistic.refresh if Statistic.count == 0

    @review_count = Statistic.find_by_identifier('review_count').value[:count]
    @people_count = Statistic.find_by_identifier('people_count').value[:count]

    @aspects = Statistic.find_by_identifier('topic_sentiments').value
    @counts = Statistic.find_by_identifier('topic_counts').value
  end

  def refresh
    Statistic.refresh
    flash[:notice] = "Stats Updated"
    redirect_to :movie_admin
  end
end
