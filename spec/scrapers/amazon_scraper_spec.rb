require 'rails_helper'
require 'spec_helper'
require 'amazon_scraper'

RSpec.describe AmazonScraper, :type => :feature do
  describe 'reviews' do
    amazon_url = 'http://www.amazon.co.uk/Godfather-DVD-Marlon-Brando/dp/B00CX5Z3R0/ref=sr_1_6?s=dvd&ie=UTF8&qid=1426187572&sr=1-6&keywords=the+godfather'
    ok_scraper = AmazonScraper.new(amazon_url, USER_AGENT_STRING, 5, false)
    empty_scraper = AmazonScraper.new('', USER_AGENT_STRING, 5, false)

    it 'gets reviews correctly' do
      VCR.use_cassette('amazon_scraper') do
        expect(ok_scraper.reviews).to_not be_nil
      end
    end

    it 'returns an empty list on 404' do
      stub_request(:any, amazon_url).to_return(:body => "abc", :status => 404, :headers => { 'Content-Length' => 3 })
      expect(ok_scraper.reviews).to eq([])
    end

    it 'returns an empty list when given no URL' do
      VCR.use_cassette('amazon_scraper') do
        expect(empty_scraper.reviews).to eq([])
      end
    end
  end
end
