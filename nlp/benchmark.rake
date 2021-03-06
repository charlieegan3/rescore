require_relative '../../config/environment'

def format_aspect_hash(aspect_hash)
  aspect_hash.
    sort_by { |k,_| k }.
    map { |aspect, score| "(#{aspect}: #{score.values.join('/')})" }.
    join(' - ')
end

def sentence_scores(sentence)
  scores = []
  words = sentence.downcase.split(/\W+/)
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
  system('clear')
  reviews = Dir['corpus/*.json']
  # reviews = ['corpus/review_c7985.json'] # enable for single review only
  exit if reviews.empty?

  sentence_count = 0

  annotations, true_positives, false_positives, sentiment_delta = 0, 0, 0, 0

  reviews.each do |annotated_review|
    print " #{annotated_review} ".black_on_green
    annotated_review = JSON.parse(File.read(annotated_review))
    puts ' - ' + annotated_review['author'].red
    rescore_review = RescoreReview.new(annotated_review['body'], nil)

    rescore_review.build_all.sentences.each_with_index do |s, i|
      sentence_count += 1
      ac = AspectComparator.new(annotated_review['annotated_sentences'][i], s)
      comparison = ac.compare

      annotations += comparison[:annotated_aspects].size
      true_positives += comparison[:scores][:true_positives]
      false_positives += comparison[:scores][:false_positives]
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
  puts "true_positives:  #{true_positives}"  + ' (correct aspects assigned by rescore)'.green
  puts "false_positives: #{false_positives}" + ' (incorrect aspects assigned by rescore)'.green
  puts "average sentiment_delta: #{(sentiment_delta.to_f / sentence_count).round(2)}" + ' (average difference (annotated vs computed) in sentiment scores)'.green

  score = (((true_positives - false_positives).to_f / annotations) * 100).to_i
  puts '-' * 50
  puts "score: #{score}%" + ' (true_positives - false_positives) of annotations'.green

  puts "precision: #{((true_positives.to_f/(true_positives+false_positives)) * 100).round(2)}%" + ' (true_positives / true_positives+false_positives)'.green
  puts "recall: #{((true_positives.to_f/(annotations)) * 100).round(2)}%" + ' (true_positives / annotations)'.green
end
