class StatisticsController < ApplicationController
  def index
    Statistic.refresh if params[:update]
    if Statistic.count == 0
      flash[:alert] = "We don't have any statistics right now, check back later!"
      return redirect_to :root
    end

    @review_count = Statistic.find_by_identifier('review_count').value[:count]
    @people_count = Statistic.find_by_identifier('people_count').value[:count]

    @aspects = Statistic.find_by_identifier('topic_sentiments').value
    @counts = Statistic.find_by_identifier('topic_counts').value
  end
end
