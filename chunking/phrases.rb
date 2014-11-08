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


puts directory = '../reviews/movie'

Dir.foreach(directory) do |item|
  next if item == '.' or item == '..'
  content = File.readlines("#{directory}/#{item}").last
  next if content.count('.') < 10
  puts content
  puts

  phrases = []
  phrase_buffer = []
  paragraph(content).segment.each do |segment|
    clean = segment.to_s.split(/\W+/).map { |word| word.downcase }.reject {|word| word == ''}
    pos = tgr.get_readable(clean.join(" ")).scan(/\/\w+/).map { |word| translations[word[1..10]].downcase }
    zipped = clean.zip(pos)
    for i in 0..zipped.size - 1
      phrase_buffer << zipped[i][0]

      next if phrase_buffer.size < 3

      unless zipped[i+1].nil?
        next if zipped[i+1][1] == 'noun'
        next if zipped[i+1][1] == 'conjunction'
      end

      if zipped[i][1] == 'noun' || i == zipped.size - 1
        phrases << phrase_buffer.join(" ")
        phrase_buffer = []
      end
    end
  end
  puts phrases

  gets
  system('clear')
end






