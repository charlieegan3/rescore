require 'rails_helper'

RSpec.describe "movies", :type => :view do
  before(:each) do
    FactoryGirl::create(:movie)
  end
  describe 'movies index' do
    it 'lists the existing films' do
      movie = Movie.first
      page.driver.browser.basic_authorize('admin', '1234qwer')
      visit ('/movies')
      expect(page).to have_xpath("//a[@href='#{movie_path(movie)}']")
    end
  end
end
