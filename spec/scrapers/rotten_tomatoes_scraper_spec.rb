require 'rails_helper'
require 'spec_helper'
require 'rotten_tomatoes_scraper'

RSpec.describe Rotten_Tomatoes_Scraper, :type => :feature do
  describe 'reviews' do
    scraper = Rotten_Tomatoes_Scraper.new('http://www.rottentomatoes.com/m/godfather/', USER_AGENT_STRING, 5, false)

    it 'gets reviews correctly' do
      VCR.use_cassette('rotten_tomatoes_scraper') do
        expect(scraper.reviews).to_not be_nil
      end
    end

    it 'returns an empty list on 404' do
      stub_request(:any, 'http://www.rottentomatoes.com/m/godfather/reviews/?page=1&type=user').to_return(:body => "abc", :status => 404, :headers => { 'Content-Length' => 3 })
      expect(scraper.reviews).to eq([])
    end
  end

  describe 'reviews' do
    scraper = Rotten_Tomatoes_Scraper.new('', USER_AGENT_STRING, 5, false)

    it 'gets reviews correctly' do
      VCR.use_cassette('rotten_tomatoes_scraper') do
        expect(scraper.reviews).to eq([])
      end
    end
  end
end
