require 'rails_helper'

RSpec.describe "application/stats", :type => :view do
  before(:each) do
    FactoryGirl::create(:movie)
  end
  it "counts the movies" do
    visit ('/stats')
    expect(page).to have_content("#{@movie_count} movies")
    expect(page).to have_content("#{@review_count} reviews")
  end
end
