require_relative '../../config/environment'

task :add_top do
  Movie.delete_all
  Delayed::Worker.delay_jobs = false
  bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
  [
    'The Shawshank Redemption (1994)',
    'The Godfather (1972)',
    'The Godfather: Part II (1974)',
    'The Dark Knight (2008)',
    'Pulp Fiction (1994)',
    '12 Angry Men (1957)',
    'Schindlers List (1993)',
    'The Good, the Bad and the Ugly (1966)',
    'The Lord of the Rings: The Return of the King (2003)',
    'Fight Club (1999)'
  ].each do |title|
    movie = bf.movies.search_by_name(title).first
    movie.genres = bf.movies.search_by_id(movie.id).genres

    Movie.create!(
      title: movie.name,
      image_url: movie.posters.thumbnail,
      year: movie.year,
      rotten_tomatoes_id: movie.id,
      rotten_tomatoes_link: movie.links['alternate'],
      genres: movie.genres,
      page_depth: 1
    )
    puts "Created Stub: #{movie.name}"
  end
  puts '***'
  Movie.all.each do |movie|
    puts "Building #{movie.title}"
    movie.populate_source_links
    movie.populate_related_people
    movie.collect_reviews
    movie.build_summary
  end
end
