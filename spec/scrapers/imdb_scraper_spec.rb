require 'rails_helper'
require 'spec_helper'
require 'imdb_scraper'

RSpec.describe Imdb_Scraper, :type => :feature do
  describe 'reviews' do
    ok_scraper = Imdb_Scraper.new('http://www.imdb.com/title/tt0068646/', USER_AGENT_STRING, 5, false)
    empty_scraper = Imdb_Scraper.new('', USER_AGENT_STRING, 5, false)

    it 'gets reviews correctly' do
      VCR.use_cassette('imdb_scraper') do
        expect(ok_scraper.reviews).to_not be_nil
      end
    end

    it 'returns an empty list on 404' do
      stub_request(:any, 'http://www.imdb.com/title/tt0068646/reviews').to_return(:body => "abc", :status => 404, :headers => { 'Content-Length' => 3 })
      expect(ok_scraper.reviews).to eq([])
    end

    it 'returns an empty array when given no URL' do
      VCR.use_cassette('imdb_scraper') do
        expect(empty_scraper.reviews).to eq([])
      end
    end
  end
end
