require 'pry'
require 'colorize'

require_relative 'review'

print 'Reading From:'.colorize(:white).on_black.underline
puts directory = 'reviews/movie'


  begin
  Integer(ARGV[0])
  rescue
    puts "Enter no. of reviews to parse as first argument.".colorize(:red)
    exit
  end

  times_extract_sentences = []
  times_include_cleaned_sentences = []
  times_evaluate_sentiment = []
  times_apply_context_tags = []
  times_apply_noun_phrases = []
  times_guess_film_name_from_text = []
  times_populate_related_people = []
  times_apply_people_tags = []
  times_get_emphasis = []
  all_times = []

  start_time = Time.now
  count = 0

  Dir.foreach(directory) do |item|

    next if item == '.' or item == '..'
    content = File.readlines("#{directory}/#{item}").last
    next if content.count('.') < 10
  
    if count >= ARGV[0].to_i
      break
    else
      count += 1
    end

    review = Review.new(content)
    times = review.time_all

    if ARGV[1] == "csv"

      all_times.push([times[:extract_sentences],
        times[:include_cleaned_sentences],
        times[:evaluate_sentiment],
        times[:apply_context_tags],
        times[:apply_noun_phrases],
        times[:guess_film_name_from_text],
        times[:populate_related_people],
        times[:apply_people_tags],
        times[:get_emphasis]])
    else
      times_extract_sentences.push(times[:extract_sentences])
      times_include_cleaned_sentences.push(times[:include_cleaned_sentences])
      times_evaluate_sentiment.push(times[:evaluate_sentiment])
      times_apply_context_tags.push(times[:apply_context_tags])
      times_apply_noun_phrases.push(times[:apply_noun_phrases])
      times_guess_film_name_from_text.push(times[:guess_film_name_from_text])
      times_populate_related_people.push(times[:populate_related_people])
      times_apply_people_tags.push(times[:apply_people_tags])
      times_get_emphasis.push(times[:get_emphasis])
    end
  end

  puts "\n\n"

  if ARGV[1] == "csv"

  puts "Average time taken for each module, over #{ARGV[0]} reviews: ".colorize(:blue)
  all_times.each do |a|
    puts a.join(',')
  end

  else
    puts "> Times taken for".colorize(:blue) + " extract_sentences".colorize(:green) + " (average: #{times_extract_sentences.inject(:+) / times_extract_sentences.length}):".colorize(:blue)
    puts "#{times_extract_sentences}"

    puts "> Times taken for".colorize(:blue) + " times_include_cleaned_sentences".colorize(:green) + " (average: #{times_include_cleaned_sentences.inject(:+) / times_include_cleaned_sentences.length}):".colorize(:blue)
    puts "#{times_include_cleaned_sentences}"

    puts "> Times taken for".colorize(:blue) + " evaluate_sentiment".colorize(:green) + " (average: #{times_evaluate_sentiment.inject(:+) / times_evaluate_sentiment.length}):".colorize(:blue)
    puts "#{times_evaluate_sentiment}"

    puts "> Times taken for".colorize(:blue) + " apply_context_tags".colorize(:green) + " (average: #{times_apply_context_tags.inject(:+) / times_apply_context_tags.length}):".colorize(:blue)
    puts "#{times_apply_context_tags}"

    puts "> Times taken for".colorize(:blue) + " apply_noun_phrases".colorize(:green) + " (average: #{times_apply_noun_phrases.inject(:+) / times_apply_noun_phrases.length}):".colorize(:blue)
    puts "#{times_apply_noun_phrases}"

    puts "> Times taken for".colorize(:blue) + " guess_film_name_from_text".colorize(:green) + " (average: #{times_guess_film_name_from_text.inject(:+) / times_guess_film_name_from_text.length}):".colorize(:blue)
    puts "#{times_guess_film_name_from_text}"

    puts "> Times taken for".colorize(:blue) + " populate_related_people".colorize(:green) + " (average: #{times_populate_related_people.inject(:+) / times_populate_related_people.length}):".colorize(:blue)
    puts "#{times_populate_related_people}"

    puts "> Times taken for".colorize(:blue) + " apply_people_tags".colorize(:green) + " (average: #{times_apply_people_tags.inject(:+) / times_apply_people_tags.length}):".colorize(:blue)
    puts "#{times_apply_people_tags}"

    puts "> Times taken for".colorize(:blue) + " get_emphasis".colorize(:green) + " (average: #{times_get_emphasis.inject(:+) / times_get_emphasis.length}):".colorize(:blue)
    puts "#{times_get_emphasis}"
  end
  
  puts "\n\n > TOTAL TIME FOR #{ARGV[0]} reviews: #{Time.now - start_time}".colorize(:blue)

