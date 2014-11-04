require 'treat'
require 'ots'
require 'engtagger'
require 'pry'
require 'colorize'

include Treat::Core::DSL
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print 'Reading From:'.colorize(:white).on_black.underline
puts directory = '../reviews/movie'

tgr = EngTagger.new
Dir.foreach(directory) do |item|
  next if item == '.' or item == '..'
  content = File.readlines("#{directory}/#{item}").last
  next if content.count('.') < 10
  print 'Review:'.colorize(:white).on_black.underline
  puts content
  puts
  paragraph(content).segment.to_a.each do |sentence|
    puts sentence
    tagged = tgr.add_tags(sentence)
    # word_list = tgr.get_words(sentence)
    # readable = tgr.get_readable(sentence)
    print ' - nouns: '.colorize(:green); puts tgr.get_nouns(tagged).keys.join(", ")
    print ' - proper: '.colorize(:red); puts tgr.get_proper_nouns(tagged).keys.join(", ")
    print ' - pt_verbs: '.colorize(:blue); puts tgr.get_past_tense_verbs(tagged).keys.join(", ")
    print ' - adj: '.colorize(:magenta); puts tgr.get_adjectives(tagged).keys.join(", ")
    print ' - nps: '.colorize(:yellow); puts tgr.get_noun_phrases(tagged).keys.join(", ")
    puts
  end
  gets
  system("clear")
end

