class PeopleSearcher
  def initialize(rotten_tomatoes_id)
    bad_fruit_client = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
    @movie = bad_fruit_client.movies.search_by_id(rotten_tomatoes_id)
  end

  def cast
    @movie.full_cast.map { |person|
      {name: person.name, characters: person.characters}
    }
  end

  def directors
    directors = @movie.directors
  end
end