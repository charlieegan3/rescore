class PotentialMovie < ActiveRecord::Base
  def self.log(query)
    rotten_tomatoes_entry = BadFruit.new(ENV['BADFRUIT_KEY'])
      .movies
      .search_by_name(query, 1)
      .first
    if (previous = existing(rotten_tomatoes_entry)).present?
      previous.delete_all
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
      page_depth: 1,
      complete: false
    ).build
  end
end
