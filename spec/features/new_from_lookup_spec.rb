require 'rails_helper'
require 'spec_helper'

Delayed::Worker.delay_jobs = false

RSpec.describe MoviesController, :type => :feature do

  before(:each) do
    page.driver.browser.basic_authorize('admin', '1234qwer')
  end

  describe 'new_from_lookup' do
    it 'rejects same two movies as choices' do
      visit('http://localhost:3000/movies/new_from_lookup')

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
