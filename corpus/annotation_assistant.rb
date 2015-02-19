puts 'You will need these gems: punkt-segmenter, securerandom, colored, json'


require 'punkt-segmenter'
require 'securerandom'
require 'colored'
require 'json'

keywords = {
  editing: {
    'editing' => 100,
    'effects' => 70,
    'post production' => 50
  },

  sound: {
    'sound' => 100,
    'music' => 100,
    'dolby' => 100,
    'audio' => 100,
    'sounds' => 100,
    'surround' => 80,
    'ears' => 20,
    'score' => 10
  },

  plot: {
    'story' => 100,
    'plot' => 100,
    'narrative' => 80,
    'predictable' => 80,
    'narration' => 80,
    'tale' => 30,
    'characters' => 50,
    'character' => 50,
    'journey' => 30,
    'persona' => 20
  },

  dialog: {
    'dialog' => 100,
    'dialogue' => 100,
    'speech' => 100,
    'spoken' => 90,
    'discussion' => 80,
    'conversation' => 80,
    'lines' => 70,
    'language' => 70,
    'delivery' => 50
  },

  cast: {
    'acting' => 100,
    'cast' => 100,
    'performance' => 90,
    'portrayal' => 90,
    'depiction' => 90,
    'characterization' => 90,
    'impersonation' => 90,
    'role' => 70,
    'persona' => 50
  },

  vision: {
    'visuals' => 100,
    'imax' => 100,
    'cgi' => 100,
    '3d' => 100,
    'graphics' => 100,
    'visual' => 100,
    'graphic' => 90,
    'colour' => 90,
    'color' => 90,
    'vision' => 90,
    'blurry' => 80,
    'lifelike' => 80,
    'screen' => 70,
    'spectacle' => 60,
    'eyes' => 30,
    'beautiful' => 20,
    'designs' => 8
  },

  length: {
    'dragged' => 100,
    'bloated' => 70,
    'boring' => 50,
    'long' => 50
  },

  credibility: {
    'true to the book' => 100,
    'believable' => 100,
    'improbable' => 100,
    'far-fetched' => 100,
    'implausible' => 100,
    'true' => 80,
    'truthful' => 80,
    'truthfully' => 70,
    'honest' => 70
  }
}



review = {}

puts 'Annotation Assistant'.blue
puts 'ctrl+C to exit any time'.red
print 'Film Title (e.g The Hobbit): '.green; review[:title] = gets.chomp
print 'Genre(s) (e.g Action, Adventure): '.green; review[:genres] = gets.chomp
print 'Review Source (e.g www.imdb.com/title/...): '.green; review[:source] = gets.chomp
print 'Review Score: (out of 10, e.g 7/10): '.green; review[:source] = gets.chomp
print 'Review Helpfulness Score: (e.g 100/120) :'.green; review[:source] = gets.chomp
print 'Your Name: '.green; review[:author] = gets.chomp
print 'Body (Paste review , type exit when done): '.green; review[:body] = ''

while(review[:body][-4..-1] != 'exit') do
  review[:body] += gets.chomp
end
review[:body] = review[:body][0..review[:body].length - 4]


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

  keywords.each do |k, v|
    v.keys.each do |term|
      aspects[k] += [term] if s.include? term
    end
  end
  puts 'Found: '.red + aspects.keys.join(', ')
  puts 'Got one too many? Enter it below to remove it.'.red
  puts 'Otherwise, enter to continue...'.green
  input = ''
  loop do
    input = gets.chomp.to_sym
    break if input == :""
    aspects.delete(input)
    puts 'Look ok? ['.red + aspects.keys.join(', ') + '] done? (enter to continue)'.red
  end

  puts 'Missed one? Enter it below.'.red
  puts 'Remember, ONLY one of these: '.black_on_red + keywords.keys.join(" ")
  puts 'Otherwise, enter to continue...'.green
  input = ''
  loop do
    input = gets.chomp.to_sym
    break if input == :""

    puts 'Enter the phrase or word that suggests this:'.red
    spotted = gets.chomp
    next if input == '' || spotted == '' || !keywords.keys.include?(input.to_sym)
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
    aspects[k] = {words: v, score: score}
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

File.open("review_#{SecureRandom.urlsafe_base64(5)}.json", 'w') { |file| file.write(JSON.pretty_generate(review)) }
