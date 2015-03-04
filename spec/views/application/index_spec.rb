require 'rails_helper'

RSpec.describe "application/index", :type => :view do
  it 'it shows the most recent movie' do
    assign(:movie, Movie.create(title: 'gladiator'))
    render
    expect(rendered).to include ('gladiator')
  end

  it 'shows the correct summary counts' do
    FactoryGirl::create(:movie)
    FactoryGirl::create(:movie, title: "The Hobbit")
    FactoryGirl::create(:review_count_statistic, identifier: 'review_count')
    FactoryGirl::create(:people_count_statistic, identifier: 'people_count')
    FactoryGirl::create(:topic_sentiments_statistic, identifier: 'topic_sentiments')
    FactoryGirl::create(:topic_counts_statistic, identifier: 'topic_counts')

    r_count = Statistic.find_by_identifier('review_count').value[:count]
    m_count = Movie.complete.size
    assign(:movie, Movie.create(title: 'gladiator'))
    assign(:review_count, r_count)
    assign(:movie_count, m_count)

    render

    expect(rendered).to include ('gladiator')
    expect(rendered).to include ("#{r_count}&nbsp;reviews revisited")
    expect(rendered).to include ("#{m_count} movies reviewed")
  end
end
