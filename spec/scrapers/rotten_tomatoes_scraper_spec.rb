require 'rails_helper'
require 'spec_helper'
require 'rotten_tomatoes_scraper'

RSpec.describe Rotten_Tomatoes_Scraper, :type => :feature do

  before(:each) do
  end

  describe 'reviews' do
    scraper = Rotten_Tomatoes_Scraper.new('http://www.rottentomatoes.com/m/godfather/', USER_AGENT_STRING, 5, false)

    it 'gets reviews correctly' do
      VCR.use_cassette('rotten_tomatoes_scraper') do
        expect(scraper.reviews).to_not be_nil
      end
    end
  end
end
