require_relative '../config/environment'
require_relative 'keywords'

review = {}

puts 'Annotation Assistant'.blue
puts 'ctrl+C to exit any time'.red
print 'Film Title (e.g The Hobbit): '.green; review[:title] = gets.chomp
print 'Genre(s) (e.g Action, Adventure): '.green; review[:genres] = gets.chomp
print 'Review Source (e.g www.imdb.com/title/...): '.green; review[:source] = gets.chomp
print 'Review Score: (out of 10, e.g 7/10): '.green; review[:score] = gets.chomp
print 'Review Helpfulness Score: (e.g 100/120) :'.green; review[:helpfulness] = gets.chomp
print 'Your Own Name: (e.g. Charlie Egan)'.green; review[:author] = gets.chomp
print 'Body (Paste review , type exit when done): '.green; review[:body] = ''

while(review[:body][-4..-1] != 'exit') do
  review[:body] += gets.chomp
end
review[:body] = review[:body][0..review[:body].length - 5]


print 'Review Entry Complete. Proceed to analysis? (y/n)'.green
exit if gets.chomp == 'n'

annotated_sentences = []

Punkt::SentenceTokenizer.new(review[:body]).
  sentences_from_text(review[:body], :output => :sentences_text).each do |s|
  system('clear')
  puts 'Sentence: '.green + s.blue
  aspects = Hash.new([])

  puts 'Does the sentence talk about the movie as a whole? (y,n)'.red
  if gets.chomp == 'y'
    puts 'Enter the phrase or word that suggests this:'.red
    spotted = gets.chomp
    aspects[:movie] = [spotted]
  end

  KEYWORDS.each do |k, v|
    v.keys.each do |term|
      aspects[k] += [term] if s.include? term
    end
  end
  puts 'Found: '.red + aspects.keys.join(', ')
  puts 'Type an element to remove it from the list'.red
  puts 'Otherwise, enter to continue...'.green
  input = ''
  loop do
    input = gets.chomp.to_sym
    break if input == :""
    aspects.delete(input)
    puts 'Look ok? ['.red + aspects.keys.join(', ') + '] done? (enter to continue)'.red
  end

  puts 'Is the list missing an aspect thats mentioned? If so, type it below'.red
  puts 'Remember, ONLY one of these: '.black_on_red + KEYWORDS.keys.join(" ")
  puts 'Otherwise, enter to continue...'.green
  input = ''
  loop do
    input = gets.chomp.to_sym
    break if input == :""

    puts 'Enter the phrase or word that suggests this:'.red
    spotted = gets.chomp
    next if input == '' || spotted == ''
    aspects[input] = [spotted]
    puts 'Look ok? ['.red + aspects.keys.join(', ') + '] done? (enter to continue)'.red
  end

  puts 'So the aspect list is:'.red
  aspects.map {|k, v|
    puts k.to_s + ':'
    puts '    Based on: ' + v.join(', ')
  }

  aspects.each do |k, v|
    puts 'Enter a sentiment score from [-2, -1, 0, 1, 2] for '.red + k.to_s
    score = gets.chomp
    puts 'Enter the key phrase or word that justifies this score for: '.red + k.to_s
    puts 'e.g. "crappy" and not "crappy movie"'.blue
    justification = gets.chomp
    aspects[k] = {words: v, score: score, justification: justification}
  end
  puts 'So the aspect list with scores is:'.red
  aspects.map {|k, v|
    puts k.to_s + ':'
    puts '    Based on: ' + v[:words].join(', ')
    puts '    Score:    ' + v[:score]
  }

  print 'Any comments? '.red; comment = gets.chomp

  annotated_sentences << {text: s, aspects: aspects, comment: comment}
end
review[:annotated_sentences] = annotated_sentences
print 'Overall Sentiment: [-2, -1, 0, 1, 2]'.red; review[:overall] = gets.chomp
print 'Final Comment: '.red; review[:comment] = gets.chomp


filename = "review_#{SecureRandom.hex(10)[0..4]}.json"
File.open(filename, 'w') { |file| file.write(JSON.pretty_generate(review)) }
system('clear')
puts "Saved: ".green + filename
