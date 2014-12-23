TRANSLATIONS = {'CC' =>      'Conjunction',
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

module NounPhrases
  class NounPhrases::Extractor
    def initialize()
      @tagger = @tagger || EngTagger.new
    end

    # this method could do with a hurna refactor
    def extract_noun_phrases(cleaned_sentence)
      cleaned_sentence = cleaned_sentence.to_s.split(/\W+/)
      return [] if cleaned_sentence.empty?

      pos = @tagger.get_readable(cleaned_sentence.join(" ")).scan(/\/\w+/).map { |word| TRANSLATIONS[word[1..10]].downcase }
      zipped = cleaned_sentence.zip(pos)

      if zipped.last[1].nil?
        #puts 'There was an error with the sentence splitter in the noun_phrase module'
        return nil
      end

      phrases = []
      phrase_buffer = []
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
      phrases.map {|phrase| phrase.map {|word_pair| word_pair[0] }.join(" ")}
    end
  end
end
