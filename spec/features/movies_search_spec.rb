require 'rails_helper'
require 'spec_helper'
require 'vcr'

Delayed::Worker.delay_jobs = false

RSpec.describe MoviesController, :type => :feature do
  #before(:each) do
  #  stub_template "application/_topics_graph.html.erb" => "This content"
  #end

  describe 'search_by_title' do
    it 'returns the correct result' do
      movie = FactoryGirl::create(:movie)

      visit('/movies/search_by_title?query=gladiator')
    
      #within("#search_form") do
      #  fill_in 'query', :with => 'Gladiator'
      #end

      #click_button 'movie_search_submit'
      expect(page).to have_content 'Gladiator'
    end
  end
end
