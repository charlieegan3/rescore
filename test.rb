require 'pry'
require 'colorize'

require_relative 'review'

print 'Reading From:'.colorize(:white).on_black.underline
puts directory = 'demo_reviews'

total_context_counts = {}

Dir.foreach(directory) do |item|

  next if item == '.' or item == '..'
  content = File.readlines("#{directory}/#{item}").join(" ")

  review = Review.new(content)
  review.build_all
  puts review.text
  review.sentences.each do |sentence|
    puts '-' * 50
    sentence.map {|k,v| print "#{k}: "; p v}
    puts "context_counts: #{total_context_counts}"
    gets
  
    sentence[:context_tags].each do |tag|
      if total_context_counts.has_key?(tag[0])
        total_context_counts[tag[0]] += sentence[:context_indexes][tag[1][0]].length if !sentence[:context_indexes][tag[1][0]].nil?
      else
        total_context_counts[tag[0]] = 0
        total_context_counts[tag[0]] = sentence[:context_indexes][tag[1][0]].length if !sentence[:context_indexes][tag[1][0]].nil?
      end
    end
  end
  puts review.film_name
  puts review.related_people

  gets
  system("clear")
end
