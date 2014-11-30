require 'pry'
require 'colorize'

require_relative 'review'

print 'Reading From:'.colorize(:white).on_black.underline
puts directory = 'reviews/movie'

if ARGV[0] == "time"

  start_time = Time.now
  count = 0

  times_extract_sentences = []
  times_include_cleaned_sentences = []
  times_evaluate_sentiment = []
  times_apply_context_tags = []
  times_apply_noun_phrases = []
  times_guess_film_name_from_text = []
  times_populate_related_people = []
  times_apply_people_tags = []
  times_get_emphasis = []

  Dir.foreach(directory) do |item|

    if count >= ARGV[1].to_i
      break
    else
      count += 1
    end

    next if item == '.' or item == '..'
    content = File.readlines("#{directory}/#{item}").last
    next if content.count('.') < 10
  
    review = Review.new(content)
    times = review.time_all

    times_extract_sentences.push(times[:extract_sentences])
    times_include_cleaned_sentences.push(times[:extract_sentences])
    times_evaluate_sentiment.push(times[:extract_sentences])
    times_apply_context_tags.push(times[:extract_sentences])
    times_apply_noun_phrases.push(times[:extract_sentences])
    times_guess_film_name_from_text.push(times[:extract_sentences])
    times_populate_related_people.push(times[:extract_sentences])
    times_apply_people_tags.push(times[:extract_sentences])
    times_get_emphasis.push(times[:extract_sentences])

    puts "-------\n"
  end

  puts "> Times taken for extract_sentences (average: #{times_extract_sentences.inject(:+) / times_extract_sentences.length}): \n #{times_extract_sentences}"

  puts "> Times taken for include_cleaned_sentences (average: #{times_include_cleaned_sentences.inject(:+) / times_include_cleaned_sentences.length}): \n #{times_include_cleaned_sentences}"

  puts "> Times taken for evaluate_sentiment (average: #{times_evaluate_sentiment.inject(:+) / times_evaluate_sentiment.length}): \n #{times_evaluate_sentiment}"

  puts "> Times taken for apply_context_tags (average: #{times_apply_context_tags.inject(:+) / times_apply_context_tags.length}): \n #{times_apply_context_tags}"

  puts "> Times taken for apply_noun_phrases (average: #{times_apply_noun_phrases.inject(:+) / times_apply_noun_phrases.length}): \n #{times_apply_noun_phrases}"

  puts "> Times taken for guess_film_name_from_text (average: #{times_guess_film_name_from_text.inject(:+) / times_guess_film_name_from_text.length}): \n #{times_guess_film_name_from_text}"

  puts "> Times taken for populate_related_people (average: #{times_populate_related_people.inject(:+) / times_populate_related_people.length}): \n #{times_populate_related_people}"

  puts "> Times taken for apply_people_tags (average: #{times_apply_people_tags.inject(:+) / times_apply_people_tags.length}): \n #{times_apply_people_tags}"

  puts "> Times taken for get_emphasis (average: #{times_get_emphasis.inject(:+) / times_get_emphasis.length}): \n #{times_get_emphasis}"

  puts "\n\n > TOTAL TIME FOR #{ARGV[1]} reviews: #{Time.now - start_time}"

else
  Dir.foreach(directory) do |item|
    next if item == '.' or item == '..'
    content = File.readlines("#{directory}/#{item}").last
    next if content.count('.') < 10
  
    review = Review.new(content)
    review.build_all
    puts review.text
    review.sentences.each do |sentence|
      puts '-' * 50
      sentence.map {|k,v| print k; p v}
      gets
    end
    puts review.film_name
    puts review.related_people
  
    gets
    system("clear")
  end
end
