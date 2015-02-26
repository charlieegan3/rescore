module Sentiment
  def Sentiment.evaluate_sentence(sentence)
    score = 0
    sentence.split(/\W+/).each do |word|
      score += POLARITIES[word] if POLARITIES[word].present?
    end
    score = 2 if score > 2
    score = -2 if score < -2
    score
  end
end
