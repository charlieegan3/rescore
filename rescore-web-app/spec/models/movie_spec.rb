require 'rails_helper'

RSpec.describe Movie, :type => :model do
  it 'should get source links' do
    movie = Movie.new(title: 'Lord of the Rings: The Fellowship of the Ring')
    VCR.use_cassette('populate_source_links') do
      movie.populate_source_links
    end
    expect(movie.imdb_link).to_not be_nil
    expect(movie.amazon_link).to_not be_nil
    expect(movie.metacritic_link).to_not be_nil
    expect(movie.rt_link).to_not be_nil
  end
end
