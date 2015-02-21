require 'rails_helper'
require 'spec_helper'
require 'vcr'

Delayed::Worker.delay_jobs = false

RSpec.describe MoviesController, :type => :feature do
  before(:each) do
    stub_template "application/_topics_graph.html.erb" => "This content"
  end

  describe 'search_by_title' do
    it 'returns the correct result' do
      # VCR.turn_off!
      # WebMock.allow_net_connect!
      movie = FactoryGirl::create(:movie)

      visit('/')
    
      within("#search_form") do
        fill_in 'query', :with => 'The Hobbit'
      end

      click_button 'movie_search_submit'
      expect(page).to have_content 'The Hobbit'
      # VCR.turn_on!
    end
  end
end
