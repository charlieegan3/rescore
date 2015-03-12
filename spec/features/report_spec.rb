require 'rails_helper'
require 'spec_helper'
require 'vcr'

RSpec.describe ReportsController, :type => :feature do
  describe 'new' do
    it 'lets users create a new report' do
      movie = FactoryGirl::create(:movie)
      create(:review_count_statistic)
      create(:people_count_statistic)
      create(:topic_sentiments_statistic)
      create(:topic_counts_statistic)
      create(:sentiment_variation_statistic)

      visit(movie_path(movie))

      within("#movie_report_form") do
       fill_in 'description', :with => 'Sentiment seems too high'
      end

      click_button 'report_form_submit'
      expect(Report.last.description).to eq('Sentiment seems too high')
      expect(Report.last.user_id).to be_nil
      expect(Report.last.category).to eq('Statistics')
    end
  end
end
