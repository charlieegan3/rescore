class ApiController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def review
  	require 'json'
    headers = ActionDispatch::Http::Headers.new(env)
    rescore_review = RescoreReview.new(headers["HTTP_REVIEW"], [])
    rescore_review.build_all_for_api
    binding.pry
    render :text => rescore_review.to_json
  end
end
