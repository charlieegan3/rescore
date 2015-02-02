require_relative '../config/environment'
Delayed::Worker.delay_jobs = false

movie = Movie.last
puts movie.title
start = Time.now

movie.build_summary

puts "build_summary completed in #{Time.now - start} for #{movie.reviews.size} reviews"

movie.save
