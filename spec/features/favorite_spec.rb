require 'rails_helper'
require 'spec_helper'

RSpec.describe MoviesController, :type => :feature do
  before(:each) do
    @movie = FactoryGirl::create(:movie)

    visit '/'
    expect(page).to have_content('Sign in with Twitter')
    mock_auth_hash
    click_link 'Sign in with Twitter'
  end

  describe 'favorite' do
    it 'can check and uncheck favorite' do
      visit(movie_path(@movie))
      expect(page).to have_css '.fi-heart.inactive'
      click_link 'favorite'
      expect(page).to have_css '.fi-heart.active'
      click_link 'favorite'
      expect(page).to have_css '.fi-heart.inactive'
    end
  end
end
