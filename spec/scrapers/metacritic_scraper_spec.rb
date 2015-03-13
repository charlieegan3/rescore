require 'rails_helper'
require 'spec_helper'
require 'metacritic_scraper'

RSpec.describe MetacriticScraper, :type => :feature do

  before(:each) do
  end

  describe 'reviews' do
    scraper = MetacriticScraper.new('http://www.metacritic.com/movie/the-godfather', USER_AGENT_STRING, 5, false)

    it 'gets reviews correctly' do
      VCR.use_cassette('metacritic_scraper') do
        expect(scraper.reviews).to_not be_nil
      end
    end
  end
end
