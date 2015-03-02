require_relative '../../config/environment'

task :build_top, :count, :pages do |t, args|
  Movie.delete_all
  Delayed::Worker.delay_jobs = false
  rotten_tomatoes_client = BadFruit.new(Bf.key)

  File.open('lib/top_50.txt').each_line.take(args[:count].to_i).each do |title|
    begin
      movie = rotten_tomatoes_client.movies.search_by_name(title.strip).first
      movie.genres = rotten_tomatoes_client.movies.search_by_id(movie.id).genres

      puts "Building #{movie.name}"
      movie = Movie.create!(
        title: movie.name,
        image_url: movie.posters.thumbnail,
        year: movie.year,
        rotten_tomatoes_id: movie.id,
        rotten_tomatoes_link: movie.links['alternate'],
        genres: movie.genres,
        page_depth: args[:pages].to_i
      )
      movie.populate_source_links
      movie.populate_related_people
      movie.collect_reviews
      movie.build_summary
    rescue Exception => e
      puts e
    end
  end
end
