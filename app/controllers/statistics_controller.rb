class StatisticsController < ApplicationController
  def refresh
    Statistic.refresh
    flash[:notice] = "Stats Updated"
    redirect_to :movie_admin
  end
end
