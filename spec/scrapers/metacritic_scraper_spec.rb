require 'rails_helper'
require 'spec_helper'
require 'metacritic_scraper'

RSpec.describe MetacriticScraper, :type => :feature do
  describe 'reviews' do
    ok_scraper = MetacriticScraper.new('http://www.metacritic.com/movie/the-godfather', USER_AGENT_STRING, 5, false)
    empty_scraper = MetacriticScraper.new('', USER_AGENT_STRING, 5, false)

    it 'gets reviews correctly' do
      VCR.use_cassette('metacritic_scraper') do
        expect(ok_scraper.reviews).to_not be_nil
      end
    end

    it 'returns an empty list on 404' do
      stub_request(:any, 'http://www.metacritic.com/movie/the-godfather/user-reviews').to_return(:body => "abc", :status => 404, :headers => { 'Content-Length' => 3 })
      expect(ok_scraper.reviews).to eq([])
    end

    it 'gets empty array with empty URL' do
      VCR.use_cassette('metacritic_scraper') do
        expect(empty_scraper.reviews).to eq([])
      end
    end
  end
end
