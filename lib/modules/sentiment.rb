module Sentiment
  def Sentiment.evaluate_sentence(sentence)
    score = 0
    sentence.split(/\W+/).each do |word|
      score += POLARITIES[word] if POLARITIES[word].present?
    end
    score
  end
end
