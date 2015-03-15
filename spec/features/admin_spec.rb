require 'rails_helper'
require 'spec_helper'

Delayed::Worker.delay_jobs = false

RSpec.describe MoviesController, :type => :feature do

  before(:each) do
    page.driver.browser.basic_authorize('admin', '1234qwer')
  end

  describe 'admin' do
    it 'lists the current movies correctly' do
#<<<<<<< HEAD
#=======
      Movie.delete_all
#>>>>>>> 426c139b98b4f8b18a8ba7b7143ee952b4874d2d
      FactoryGirl::create(:movie, title: 'Alien')
      visit('/movies/admin')
      expect(page).to have_content 'Alien'
    end

    it 'lets admin udpate stats properly' do
#<<<<<<< HEAD
#=======
      Movie.delete_all
#>>>>>>> 426c139b98b4f8b18a8ba7b7143ee952b4874d2d
      FactoryGirl::create(:movie, title: 'Alien')
      visit('/movies/admin')
      expect(page).to have_content 'Refresh Average Stats'
      click_on 'refresh_stats_btn'
      expect(page).to have_content 'Stats Updated'
      expect(Statistic.count).to eq(5)
    end

    it 'lets admin delete movies' do
#<<<<<<< HEAD
      pending "the movie shouldn't be on the list after 'delete' is clicked."
    end

    it 'lets admin manage movies' do
      pending "Clicking 'manage' should take user to manage page."
#=======
      Movie.delete_all
      FactoryGirl::create(:movie, title: 'Alien')
      FactoryGirl::create(:movie, title: 'The Godfather')
      visit('/movies/admin')
      first('.button.alert').click
      #click_on 'Delete'
      expect(page).not_to have_content 'Alien'
    end

    it 'lets admin manage movies' do
      Movie.delete_all
      FactoryGirl::create(:movie, title: 'Alien')
      visit('/movies/admin')
      click_on 'Manage'
      expect(page).to have_content 'Rotten Tomatoes ID'
#>>>>>>> 426c139b98b4f8b18a8ba7b7143ee952b4874d2d
    end
  end

  describe 'new_from_lookup' do
    it 'rejects same two movies as choices' do
      visit('/movies/new_from_lookup')

      within("#new_from_lookup_form") do
       fill_in 'query', with: 'The Godfather'
      end

#<<<<<<< HEAD
      click_button 'new_from_lookup_btn'
      expect(page).to have_content '12911' # ID

      first('.button_alert').click
#=======
      VCR.use_cassette('new_from_lookup') do
        click_button 'new_from_lookup_btn'
      end
      expect(page).to have_content '12911' # ID

      first('.button.alert').click
#>>>>>>> 426c139b98b4f8b18a8ba7b7143ee952b4874d2d
      expect(page).to have_content 'New Film'

      click_button 'new_film_submit'
      expect(page).to have_content 'The Godfather'
    end
  end
end
