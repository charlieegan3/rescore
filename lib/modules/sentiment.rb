module Sentiment
  def Sentiment.evaluate_sentence(sentence)
    score = 0
    sentence.split(/\s+/).each do |word|
      score += POLARITIES[word] if POLARITIES[word].present?
    end
    score
  end
end
