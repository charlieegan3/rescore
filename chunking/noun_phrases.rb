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
    next if clean.empty?
    pos = tgr.get_readable(clean.join(" ")).scan(/\/\w+/).map { |word| translations[word[1..10]].downcase }
    zipped = clean.zip(pos)
    for i in 0..zipped.size - 1
      current_state = phrase_buffer.map {|word| word[1]}.join
      next_state = current_state + zipped[i][1]
      if next_state.match(/(^(determiner)?(adverb)*(adjective)*noun$)/)
        phrase_buffer << zipped[i]
      elsif current_state.match(/(^(determiner)?(adverb)*(adjective)*noun$)/)
        phrases << phrase_buffer
        phrase_buffer = [zipped[i]]
      elsif next_state.match(/(^(determiner)?(adverb)*(adjective)*$)/)
        phrase_buffer << zipped[i]
        next
      else
        phrase_buffer = [zipped[i]]
      end
    end
    phrases << phrase_buffer if phrase_buffer.map {|word| word[1]}.join.match(/(^(determiner)?(adverb)*(adjective)*noun$)/)
    phrase_buffer = []
  end
  phrases.select! {|x| x.size > 2}
  phrases = phrases.map {|x| x.map {|y| y[0]}.join(" ") }
  phrases = phrases.sort_by {|x| x.length}.reverse
  puts phrases
  phrases = []

  gets
  system('clear')
end






