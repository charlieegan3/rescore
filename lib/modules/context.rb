require 'ots'
require_relative 'utils'

module Context
  def Context.tag_sentence(sentence)
    sentence_tags = Hash.new([])

    ASPECTS.each do |context, terms|
      terms.keys.each do |term|
        sentence_tags[context] += [terms[term]] if sentence.match(/(\W|\A)#{term}(\W|\z)/)
      end
    end

    sentence_tags.map { |k, v| sentence_tags[k] = v.reduce(:+) / sentence_tags.size }

    return sentence_tags
  end
end
