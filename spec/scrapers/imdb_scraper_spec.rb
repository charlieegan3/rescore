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
  end
end
