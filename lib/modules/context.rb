require 'ots'
require_relative 'utils'

module Context
  def Context.tag_sentence(sentence)
    sentence_tags = Hash.new([])

    keywords = sentence.gsub(/\W/, ' ').split(/\s+/).
      select { |word| word.length > 3 }

    ASPECTS.each do |context, terms|
      keywords.each do |keyword|
        if terms.keys.include? keyword
          sentence_tags[context] += [terms[keyword]]
        end
      end
    end

    sentence_tags.map { |k, v| sentence_tags[k] = v.reduce(:+) / sentence_tags.size }

    return sentence_tags
  end
end
