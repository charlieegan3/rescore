class StatCalculator
  def initialize(reviews)
    @reviews = reviews
  end

  def topic_counts
    Hash[ASPECTS.map {|k,v| [k, 0]}].tap do |topic_counts|
      @reviews.map { |r| r[:rescore_review] }.each do |review|
        next if review.nil?
        review.each do |sentence|
          sentence[:context_tags].keys.each { |t| topic_counts[t] += 1 }
        end
      end
    end
  end

  def rating_distribution
    [].tap do |rating_distribution|
      rounded_ratings = rounded(@reviews.map { |r| r[:percentage] })
      (0..100).step(10) do |n|
        rating_distribution << rounded_ratings.count(n)
      end
    end
  end

  private
    def rounded(ratings)
      ratings.map { |r| (r / 10 unless r.nil?).to_i * 10 }
    end
end
