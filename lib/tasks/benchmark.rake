require_relative '../../config/environment'

def format_aspect_hash(aspect_hash)
  aspect_hash.
    sort_by { |k,_| k }.
    map { |aspect, score| "#{aspect}: #{score}" }.
    join(', ')
end

task :benchmark, :print do |t, args|
  sentiment_analyzer = Sentiment::SentimentAnalyzer.new

  reviews = Dir['corpus/*.json']
  exit if reviews.empty?

  annotations, correct, wrong, sentiment_delta = 0, 0, 0, 0

  reviews.each do |annotated_review|
    puts " #{annotated_review} ".black_on_green
    annotated_review = JSON.parse(File.read(annotated_review))
    rescore_review = RescoreReview.new(annotated_review['body'], nil)

    rescore_review.build_all(sentiment_analyzer).each_with_index do |s, i|
      ac = AspectComparator.new(annotated_review['annotated_sentences'][i], s)
      comparison = ac.compare

      annotations += comparison[:annotated_aspects].size
      correct += comparison[:scores][:correct]
      wrong += comparison[:scores][:wrong]
      sentiment_delta += comparison[:scores][:delta]

      next if (comparison[:annotated_aspects] == comparison[:computed_aspects]) || args[:print].nil?

      puts " #{i + 1}:".yellow_on_black + ' ' + s[:text]
      puts "Annotated: ".cyan + format_aspect_hash(comparison[:annotated_aspects]).blue
      puts "Computed:  ".cyan + format_aspect_hash(comparison[:computed_aspects]).blue
    end
  end

  puts '=' * 50
  puts ' Summary '.white_on_black

  puts "annotations:     #{annotations}"     + ' (aspects assigned by us)'.green
  puts "correct:         #{correct}"         + ' (correct aspects assigned by rescore)'.green
  puts "wrong:           #{wrong}"           + ' (incorrect aspects assigned by rescore)'.green
  puts "sentiment_delta: #{sentiment_delta}" + ' (total difference (annotated vs computed) in sentiment scores)'.green

  score = (((correct - wrong).to_f / annotations) * 100).to_i
  puts '-' * 50
  puts "score: #{score}%" + ' (correct - wrong) of annotations'.green
end
