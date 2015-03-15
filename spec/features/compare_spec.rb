require 'rails_helper'
require 'spec_helper'
require 'vcr'

Delayed::Worker.delay_jobs = false

RSpec.describe MoviesController, :type => :feature do

  before(:each) do
    @movie = FactoryGirl::create(:movie, title: "The Matrix")
    @movie2 = FactoryGirl::create(:movie, title: "The Hobbit")
  end

  describe 'compare' do
    it 'rejects same two movies as choices' do
      visit('/movies/compare')

      within("#compare_form") do
       page.select @movie.title, :from => 'm1_select'
       page.select @movie.title, :from => 'm2_select'
      end

      click_button 'compare_submit'
      expect(page).to have_content 'Please choose different films to compare.'
    end

    it 'accepts two different movies as choices' do
      visit('/movies/compare')

      within("#compare_form") do
       page.select @movie.title, :from => 'm1_select'
       page.select @movie2.title, :from => 'm2_select'
      end

      click_button 'compare_submit'
      expect(page).to have_content 'Comparing'
    end
  end
end
