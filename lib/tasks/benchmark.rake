require_relative '../../config/environment'

def format_aspect_hash(aspect_hash)
  aspect_hash.
    sort_by { |k,_| k }.
    map { |aspect, score| "(#{aspect}: #{score.values.join('/')})" }.
    join(' - ')
end

def sentence_scores(sentence)
  scores = []
  words = sentence.split(/\W+/)
  words.each do |word|
    score = POLARITIES[word] || '?'
    if score.to_s.include? '?'
      scores << score.to_s.rjust(word.length).white
    else
      scores << score.to_s.rjust(word.length).red
    end
  end
  puts words.join(' ')
  puts scores.join(' ')
end

task :benchmark, :print do |t, args|
  reviews = Dir['corpus/*.json']
  # reviews = ['corpus/review_c7985.json'] # enable for single review only
  exit if reviews.empty?

  annotations, correct, wrong, sentiment_delta = 0, 0, 0, 0

  reviews.each do |annotated_review|
    print " #{annotated_review} ".black_on_green
    annotated_review = JSON.parse(File.read(annotated_review))
    puts ' - ' + annotated_review['author'].red
    rescore_review = RescoreReview.new(annotated_review['body'], nil)

    rescore_review.build_all.sentences.each_with_index do |s, i|
      ac = AspectComparator.new(annotated_review['annotated_sentences'][i], s)
      comparison = ac.compare

      annotations += comparison[:annotated_aspects].size
      correct += comparison[:scores][:correct]
      wrong += comparison[:scores][:wrong]
      sentiment_delta += comparison[:scores][:delta]

      if comparison[:annotated_aspects].size == comparison[:computed_aspects].size
        pass = comparison[:annotated_aspects].map do |k, v|
          if comparison[:computed_aspects][k].nil?
            false
          else
            comparison[:computed_aspects][k][:score] == v[:score]
          end
        end.uniq == [true] || comparison[:computed_aspects] == {} && comparison[:annotated_aspects] == {}
      else
        pass = false
      end

      next if pass ||  args[:print].nil?

      puts " #{i + 1}:".yellow_on_black + ' ' + s[:text]
      puts "Annotated: ".cyan + format_aspect_hash(comparison[:annotated_aspects]).blue
      puts "Computed:  ".cyan + format_aspect_hash(comparison[:computed_aspects]).blue
      sentence_scores(s[:text])
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
