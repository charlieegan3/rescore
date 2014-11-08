require 'pry'

require 'simple_sentiment'
require 'sad_panda'
require 'sentiment_lib'
require 'sentimental'

require 'treat'

include Treat::Core::DSL
Sentimental.load_defaults
sentimental_analyzer = Sentimental.new
sentimentlib_analyzer = SentimentLib::Analyzer.new(:strategy => ::SentimentLib::Analysis::Strategies::BasicDictStrategy.new)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

puts directory = '../reviews/movie'

def sentiment(sentence, sentimental_analyzer, sentimentlib_analyzer)
  scores = []
  scores << (SimpleSentiment.sentiment(sentence).score.to_f / 10).round(2) rescue simple_sentiment_scores << 0
  scores << ((SadPanda.polarity(sentence) - 5).to_f / 3).round(2)
  scores << sentimentlib_analyzer.analyze(sentence).to_f.round(2)
  scores << sentimental_analyzer.get_score(sentence).to_f.round(2)
  total = scores.reduce(:+).to_f
  average = total / 4
  corrected_average = ((total - scores.sort_by {|x| (average - x).abs }.last) / 4).round(2)
  [corrected_average, average, scores]
end


count = 0
Dir.foreach(directory) do |item|
  next if item == '.' or item == '..'
  content = File.readlines("#{directory}/#{item}").last
  paragraph(content).segment.to_a.each do |sentence|
    p sentence = sentence.to_s.split(/\W+/).map { |word| word.downcase }.reject {|word| word == ''}.join(' ')
    p sentiment(sentence, sentimental_analyzer, sentimentlib_analyzer)[0]
    gets
  end
  gets
end


