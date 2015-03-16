require 'rails_helper'
require 'spec_helper'

RSpec.describe MoviesController, :type => :feature do
  before(:each) do
    @movie = FactoryGirl::create(:movie)

    visit '/'
    expect(page).to have_content('Sign in with Twitter')
    mock_auth_hash
    first('.twitter-signin-btn').click
  end

  describe 'favorite' do
    it 'can check and uncheck favorite' do
      visit(movie_path(@movie))
      expect(page).to have_css '.fi-heart.inactive'
      click_link 'favorite'
      expect(page).to have_css '.fi-heart.active'
      expect(Favorite.count).to eq(1)
      click_link 'favorite'
      expect(page).to have_css '.fi-heart.inactive'
      expect(Favorite.count).to eq(0)
    end
  end
end
