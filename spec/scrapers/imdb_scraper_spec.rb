require 'rails_helper'
require 'spec_helper'
require 'imdb_scraper'

RSpec.describe Imdb_Scraper, :type => :feature do

  before(:each) do
  end

  describe 'reviews' do
    scraper = Imdb_Scraper.new('http://www.imdb.com/title/tt0068646/', USER_AGENT_STRING, 5, false)

    it 'gets reviews correctly' do
      VCR.use_cassette('imdb_scraper') do
        expect(scraper.reviews).to_not be_nil
      end
    end

    it 'returns an empty list on 404' do
      stub_request(:any, 'http://www.imdb.com/title/tt0068646/reviews').to_return(:body => "abc", :status => 404, :headers => { 'Content-Length' => 3 })
      expect(scraper.reviews).to eq([])
    end
  end
  describe 'reviews' do
    scraper = Imdb_Scraper.new('', USER_AGENT_STRING, 5, false)
    
    it 'gets empty array for empty URL' do
      VCR.use_cassette('imdb_scraper') do
        expect(scraper.reviews).to eq([])
      end
    end
  end
end
