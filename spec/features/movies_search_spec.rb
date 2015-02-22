require 'rails_helper'
require 'spec_helper'
require 'vcr'

Delayed::Worker.delay_jobs = false

RSpec.describe MoviesController, :type => :feature do
  before(:each) do
    movie = FactoryGirl::create(:movie)
  end

  describe 'manage' do
    it 'lists the existing films' do
      visit ('/movies')
      expect(page).to have_content 'Gladiator'
    end
  end

  describe 'search_by_title' do
    it 'returns the correct result' do
      visit('/')

      within("#search_form") do
       fill_in 'query', :with => 'Gladiator'
      end

      click_button 'movie_search_submit'
      expect(page).to have_content 'Gladiator'
    end
  end
end
