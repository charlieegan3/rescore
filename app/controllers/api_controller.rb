class ApiController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token  #bypass authentication - to be done properly later!
  def index
      render "index"
  end

  def review
    rescore_review = RescoreReview.new(params["review"], nil)
    # render layout: false  #for some reason this gives a "missing template" error
    rescore_review.build_all
    render json: rescore_review
  end
end
