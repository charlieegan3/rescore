class SentimentCalculator
  def initialize(reviews)
    @reviews = reviews

    @topics_sentiment = Hash[ASPECTS.map {|k,v| [k, []]}]
    @people_sentiment = Hash.new([])
    @sentence_sentiment = []
    @review_sentiment = []
  end

  def build
    @reviews.each do |review|
      next if review[:rescore_review].nil? || review[:rescore_review].empty?
      review[:rescore_review].each do |s|
        @sentence_sentiment << s[:sentiment]
        s[:context_tags].keys.each { |tag| @topics_sentiment[tag] << s[:sentiment] * s[:context_tags][tag] }
        s[:people_tags].each { |tag| @people_sentiment[tag] << s[:sentiment] }
      end
      @review_sentiment << @sentence_sentiment.last(review[:rescore_review].size).reduce(:+) / review[:rescore_review].size
    end
  end

  def topics_sentiment
    counts = Hash[@topics_sentiment.map { |k, v| [k, v.reduce(:+) / v.size] }]
    total = counts.inject(0) {|sum, k| sum += k[1] }
    counts.inject(counts) { |h,(k,v)| h[k] = v.to_f / total; h }
  end

  def people_sentiment
    @people_sentiment = @people_sentiment.sort_by { |_, v| v.size }
    @people_sentiment = @people_sentiment.
      map { |k, v| [k, v.reduce(:+) / v.size, v.size] }.reverse.
      reject { |_, _, c| c < 3}.
      sort_by { |_, v, c| (v * 100).to_f / c }.reverse
  end

  def sentence_sentiment
    @sentence_sentiment = dup_hash(@sentence_sentiment.map {|x| x.round(1)}).to_a.sort_by { |x| x[0] }
    mean = @sentence_sentiment.map { |x| x[0] }.mean
    standard_deviation = @sentence_sentiment.map { |x| x[0] }.standard_deviation
    @sentence_sentiment.map! { |x| [((x[0] - mean) / standard_deviation).round(2), x[1]] }
    labels = [0, @sentence_sentiment.size - 1, @sentence_sentiment.size / 2, @sentence_sentiment.size / 4, @sentence_sentiment.size - @sentence_sentiment.size / 4]
    @sentence_sentiment.each_with_index do |x, i|
      @sentence_sentiment[i] = ['', x[1]] unless labels.include? i
    end
    @sentence_sentiment
  end

  def review_sentiment
    values = dup_hash(@review_sentiment).sort_by { |k, _| k }.map { |k, v| v }
    {range: @review_sentiment.max - @review_sentiment.min, st_dev: @review_sentiment.standard_deviation, values: values}
  end

  def location_sentiment
    sentiment = @reviews.map {|x| [x[:location], x[:rescore_review].map {|x| x[:sentiment]}.mean]}
    sentiment.reject! { |e| e.first == '' || e.first.nil? }
    sentiment = sentiment.group_by { |e| e[0]}.to_a.select { |e| e[1].size > 1 }
    sentiment = sentiment.map { |e| [e[0], e[1].map { |e2| e2[1] }.reduce(:+), e[1].size ] }.sort_by { |e| e[1] }.reverse
    sentiment.map { |e| [e[0].gsub('from ', ''), e[1].round(2) * 100, e[2]] }
  end

  private
    def dup_hash(ary)
     ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select {
     |k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
    end
end
