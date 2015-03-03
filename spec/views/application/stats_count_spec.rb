require 'rails_helper'

RSpec.describe "application/stats", :type => :view do
  before(:each) do
    FactoryGirl::create(:movie)
    FactoryGirl::create(:review_count_statistic)
    FactoryGirl::create(:topic_counts_statistic)
    FactoryGirl::create(:topic_sentiments_statistic)
    FactoryGirl::create(:people_count_statistic)
  end
  it "counts the movies" do
    review_count = Statistic.find_by_identifier('review_count').value[:count]
    people_count = Statistic.find_by_identifier('people_count').value[:count]
    aspects = Statistic.find_by_identifier('topic_sentiments').value
    counts = Statistic.find_by_identifier('topic_counts').value

    visit ('/stats')
    expect(page).to have_content("#{Movie.count} movies")
    expect(page).to have_content("#{review_count} reviews")
    expect(page).to have_content("#{people_count} people")
  end
end
