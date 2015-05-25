class RescoreReviewer
  def initialize(reviews, related_people)
    @reviews = reviews
    @related_people = related_people
  end

  def rescored_reviews
    [].tap do |rescored_reviews|
      @reviews.each_with_index do |review, index|
        rescore_review = RescoreReview.new(review[:content], @related_people)
        review[:rescore_review] = rescore_review.build_all.sentences
        rescored_reviews << review
      end
    end
  end
end
