require 'rails_helper'
require 'spec_helper'

RSpec.describe StatisticsController, :type => :controller do

  describe 'index' do
    it 'displays if there are enough statistics' do
      review_count = FactoryGirl::create(:review_count_statistic, identifier: 'review_count')
      people_count = FactoryGirl::create(:people_count_statistic, identifier: 'people_count')
      topic_sentiments = FactoryGirl::create(:topic_sentiments_statistic, identifier: 'topic_sentiments')
      topic_counts = FactoryGirl::create(:topic_counts_statistic, identifier: 'topic_counts')
      get :index
      expect(response).to render_template('index')
    end
  end
end
