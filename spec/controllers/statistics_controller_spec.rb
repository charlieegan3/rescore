require 'rails_helper'
require 'spec_helper'

RSpec.describe StatisticsController, :type => :controller do

  describe 'index' do
    it 'displays if there are enough statistics' do
      review_count = FactoryGirl::create(:statistic, identifier: 'review_count')
      people_count = FactoryGirl::create(:statistic, identifier: 'people_count')
      topic_sentiments = FactoryGirl::create(:statistic, identifier: 'topic_sentiments')
      topic_counts = FactoryGirl::create(:statistic, identifier: 'topic_counts')
      get :index
      expect(response).to render_template('index')
    end

    it 'redirects if there are not enough statistics' do
      get :index
      expect(response).to redirect_to '/'
    end
  end
end
