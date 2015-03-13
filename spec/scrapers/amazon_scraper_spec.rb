require 'rails_helper'
require 'spec_helper'
require 'amazon_scraper'

RSpec.describe AmazonScraper, :type => :feature do

  before(:each) do
  end

  describe 'reviews' do
    scraper = AmazonScraper.new('http://www.amazon.co.uk/Godfather-DVD-Marlon-Brando/dp/B00CX5Z3R0/ref=sr_1_6?s=dvd&ie=UTF8&qid=1426187572&sr=1-6&keywords=the+godfather', USER_AGENT_STRING, 5, false)

    it 'gets reviews correctly' do
      VCR.use_cassette('amazon_scraper') do
        expect(scraper.reviews).to_not be_nil
      end
    end
  end
end
