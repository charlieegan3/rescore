require 'rails_helper'
require 'spec_helper'

RSpec.describe MoviesController, :type => :feature do
  before(:each) do
    @movie = FactoryGirl::create(:movie)
    create(:review_count_statistic)
    create(:people_count_statistic)
    create(:topic_sentiments_statistic)
    create(:topic_counts_statistic)
    create(:sentiment_variation_statistic)

    visit '/'
    expect(page).to have_content('Sign in with Twitter')
    mock_auth_hash
    click_link 'Sign in with Twitter'
  end

  describe 'favorite' do
    it 'can check and uncheck favorite' do
      visit(movie_path(@movie))
      click_link 'favorite'
      expect(page).to have_css '.fi-heart.inactive'
      click_link 'favorite'
      expect(page).to have_css '.fi-heart.active'
    end
  end
end
