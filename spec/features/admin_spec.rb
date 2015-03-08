require 'rails_helper'
require 'spec_helper'

Delayed::Worker.delay_jobs = false

RSpec.describe MoviesController, :type => :feature do

  before(:each) do
    page.driver.browser.basic_authorize('admin', '1234qwer')
  end

  describe 'admin' do
    it 'lists the current movies correctly' do
      FactoryGirl::create(:movie, title: 'Alien')
      visit('/movies/admin')
      expect(page).to have_content 'Alien'
    end

    it 'lets admin udpate stats properly' do
      FactoryGirl::create(:movie, title: 'Alien')
      visit('/movies/admin')
      expect(page).to have_content 'Refresh Average Stats'
      click_on 'refresh_stats_btn'
      expect(page).to have_content 'Stats Updated'
      expect(Statistic.count).to eq(5)
    end

    it 'lets admin delete movies' do
      FactoryGirl::create(:movie, title: 'Alien')
      visit('/movies/admin')
      click_on 'Delete'      
      expect(page).not_to have_content 'Alien'
    end

    it 'lets admin manage movies' do
      FactoryGirl::create(:movie, title: 'Alien')
      visit('/movies/admin')
      click_on 'Manage'
      expect(page).to have_content 'Rotten Tomatoes ID'
    end
  end

  describe 'new_from_lookup' do
    it 'rejects same two movies as choices' do
      visit('/movies/new_from_lookup')

      within("#new_from_lookup_form") do
       fill_in 'query', with: 'The Godfather'
      end

      click_button 'new_from_lookup_btn'
      expect(page).to have_content '12911' # ID

      first('.button_alert').click
      expect(page).to have_content 'New Film'

      click_button 'new_film_submit'
      expect(page).to have_content 'The Godfather'
    end
  end
end
