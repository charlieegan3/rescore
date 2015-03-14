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

    it 'returns an empty list on 404' do
      stub_request(:any, 'http://www.metacritic.com/movie/the-godfather/user-reviews').to_return(:body => "abc", :status => 404, :headers => { 'Content-Length' => 3 })
      expect(scraper.reviews).to eq([])
    end
  end
end
