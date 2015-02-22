module Sentiment
  class Sentiment::SentimentAnalyzer
    def initialize()
      Sentimental.load_defaults
      @sentimental_analyzer = Sentimental.new
      @sentimentlib_analyzer = SentimentLib::Analyzer.new(:strategy => ::SentimentLib::Analysis::Strategies::BasicDictStrategy.new)
    end

    def get_sentiment(sentence)
      scores = []
      scores << (SimpleSentiment.sentiment(sentence).score.to_f / 10).round(2) rescue scores << 0
      scores << ((SadPanda.polarity(sentence) - 5).to_f / 6).round(2)
      scores << @sentimentlib_analyzer.analyze(sentence).to_f.round(2) / 2
      scores << @sentimental_analyzer.get_score(sentence).to_f.round(2) / 2
      emphasis = Emphasis.score(sentence).to_f
      total = scores.reduce(:+).to_f
      weighted_total = total * emphasis
      average = total / 4
      corrected_average = ((total - scores.sort_by {|x| (average - x).abs }.last) / 4).round(2)
      {average: average, corrected_average: corrected_average, scores: scores, total: total, weighted_total: weighted_total}
    end
  end
end
