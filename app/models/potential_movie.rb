class PotentialMovie < ActiveRecord::Base
  def self.log(query)
    bad_fruit_client = BadFruit.new(ENV['BADFRUIT_KEY'])
    rotten_tomatoes_entry = bad_fruit_client.movies
      .search_by_name(query, 1)
      .first
    if (previous = existing(rotten_tomatoes_entry)).present?
      previous.delete_all
      rotten_tomatoes_entry.genres =
        bad_fruit_client.movies.search_by_id(rotten_tomatoes_entry.id).genres
      create_movie(rotten_tomatoes_entry)
    else
      create({query: query, rotten_tomatoes_id: rotten_tomatoes_entry.id})
    end
  end

  def self.existing(rotten_tomatoes_entry)
    where({rotten_tomatoes_id: rotten_tomatoes_entry.id})
  end

  def self.create_movie(rotten_tomatoes_entry)
    Movie.create(
      title: rotten_tomatoes_entry.name,
      image_url: rotten_tomatoes_entry.posters.thumbnail,
      year: rotten_tomatoes_entry.year,
      rotten_tomatoes_id: rotten_tomatoes_entry.id,
      rotten_tomatoes_link: rotten_tomatoes_entry.links['alternate'],
      genres: rotten_tomatoes_entry.genres,
      page_depth: 3,
      complete: false
    ).build
  end
end
