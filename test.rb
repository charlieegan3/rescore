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
    puts "context_counts: #{total_context_counts}" # See comment at bottom.
    gets
  
    sentence[:context_tags].each do |tag|
      if total_context_counts.has_key?(tag[0])
        #puts total_context_counts
        #puts "YOLOOOOOOOOOOOO: #{tag[0]}"
        #puts "YOLOOOOOOOOOOOO: #{tag[1]}"
        #puts "YOLOOOOOOOOOOOO: #{sentence[:context_indexes][tag[0]]}"
        #puts "YOLOOOOOOOOOOOO: #{sentence[:context_indexes][tag[1]]}"
        #gets
        #total_context_counts[tag[0]] += sentence[:context_indexes][tag[1]] if !sentence[:context_indexes][tag[1]].nil?
        total_context_counts[tag[0]] += tag[1].length if !tag[1].nil? && !tag[1].empty? # Does not count more than one tag in a sentence.
      else
        total_context_counts[tag[0]] = 0
        total_context_counts[tag[0]] += tag[1].length if !tag[1].nil? && !tag[1].empty? # Ditto.
        #total_context_counts[tag[0]] = sentence[:context_indexes][tag[1]]
      end
    end
  end
  puts review.film_name
  puts review.related_people

  gets
  system("clear")
end

# Currently total_context_counts is gathered naively by just summing the number of words belonging to a context in a sentence.
# E.g:
#    If 'effects', 'scenery', and 'visuals' are all mentioned 2 times each in a sentence, 
#    total_context_counts will only be 3 (not 6) because the repetitions are not counted.
