require 'pry'
require 'colorize'

require_relative 'review'

print 'Reading From:'.colorize(:white).on_black.underline
puts directory = 'demo_reviews'

Dir.foreach(directory) do |item|

  next if item == '.' or item == '..'
  content = File.readlines("#{directory}/#{item}").join(" ")
  p content

  # review = Review.new(content)
  # review.build_all
  # puts review.text
  # review.sentences.each do |sentence|
  #   puts '-' * 50
  #   sentence.map {|k,v| print k; p v}
  #   gets
  # end
  # puts review.film_name
  # puts review.related_people

  # gets
  # system("clear")
end
