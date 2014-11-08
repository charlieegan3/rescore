require 'treat'
require 'pry'
require 'colorize'
require 'engtagger'


translations = {'CC' =>      'Conjunction',
'CD' =>      'Adjective',
'DET' =>     'Determiner',
'EX' =>      'Pronoun',
'FW' =>      'Foreign',
'IN' =>      'Preposition',
'JJ' =>      'Adjective',
'JJR' =>     'Adjective',
'JJS' =>     'Adjective',
'LS' =>      'Symbol',
'MD' =>      'Verb',
'NN' =>      'Noun',
'NNP' =>     'Noun',
'NNPS' =>    'Noun',
'NNS' =>     'Noun',
'PDT' =>     'Determiner',
'POS' =>     'Possessive',
'PRP' =>     'Determiner',
'PRPS' =>    'Determiner',
'RB' =>      'Adverb',
'RBR' =>     'Adverb',
'RBS' =>     'Adverb',
'RP' =>      'Adverb',
'SYM' =>     'Symbol',
'TO' =>      'Preposition',
'UH' =>      'Interjection',
'VB' =>      'Verb',
'VBD' =>     'Verb',
'VBG' =>     'Verb',
'VBN' =>     'Verb',
'VBP' =>     'Verb',
'VBZ' =>     'Verb',
'WDT' =>     'Determiner',
'WP' =>      'Pronoun',
'WPS' =>     'Determiner',
'WRB' =>     'Adverb',
'PP' =>      'Punctuation',
'PPC' =>     'Punctuation',
'PPD' =>     'Punctuation',
'PPL' =>     'Punctuation',
'PPR' =>     'Punctuation',
'PPS' =>     'Punctuation',
'LRB' =>     'Punctuation',
'RRB' =>     'Punctuation'}

include Treat::Core::DSL
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

tgr = EngTagger.new

def phrases_of_length(array, length=2)
  phrases = []
  for i in 0..array.size - 1
    phrases << [array[i,length]] if i + length < array.size
  end
  phrases
end

puts directory = '../reviews/movie'

Dir.foreach(directory) do |item|
  next if item == '.' or item == '..'
  content = File.readlines("#{directory}/#{item}").last
  next if content.count('.') < 10
  puts content
  puts

  paragraph(content).segment.each do |segment|
    clean = segment.to_s.split(/\W+/).map { |word| word.downcase }.reject {|word| word == ''}

    phrases_of_length(clean).each do |phrase|
      syntax = tgr.get_readable(phrase.join(" ")).scan(/\/\w+/).map { |word| translations[word[1..10]].downcase }.join("")
      if syntax == 'adjectivenoun'
        puts phrase.join(" ")
      end
    end
  end

  gets
  system('clear')
end






