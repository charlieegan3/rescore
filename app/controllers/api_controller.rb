class ApiController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def review
    headers = ActionDispatch::Http::Headers.new(env)
    rescore_review = RescoreReview.new(headers["HTTP_REVIEW"], nil)
    if (rescore_review.text.blank?)
      render "index"
    else 
      rescore_review.build_all
      render json: rescore_review
    end
  end
end
