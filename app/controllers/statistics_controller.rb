class StatisticsController < ApplicationController
  def index
    @statistics = Statistic.all
  end
end
