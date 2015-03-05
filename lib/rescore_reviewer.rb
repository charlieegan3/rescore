class RescoreReviewer
  def initialize(movie)
    @movie = movie
    @count = @movie.reviews.size
  end

  def rescored_reviews
    [].tap do |rescored_reviews|
      @movie.reviews.each_with_index do |review, index|
        update_status(index) if index % 50 == 0
        rescore_review = RescoreReview.new(review[:content], @movie.related_people)
        review[:rescore_review] = rescore_review.build_all.sentences
        rescored_reviews << review
      end
    end
  end

  private
    def update_status(index)
      @movie.update_attribute(
        :status, "#{(index.to_f/@count).round(2) * 100}%"
      )
    end
end
