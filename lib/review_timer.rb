# Time the entire build process for a movie.
# NOTE: turn off 'handle_asynchronously' in the movie.rb first.

require_relative '../config/environment'

movie = Movie.last
start = Time.now

movie.build_summary

puts "build_summary completed in #{Time.now - start} for #{movie.reviews.size} reviews"

movie.save
