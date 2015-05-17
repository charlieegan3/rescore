require 'rails_helper'
require 'spec_helper'

RSpec.describe MoviesController, :type => :controller do
  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(ENV['ADMIN_USERNAME'], ENV['ADMIN_PASSWORD'])
  end

  describe 'index' do
    it 'builds a list of movies' do
      movie = FactoryGirl::create(:movie)
      get :index
      expect(assigns(:movies)).to match_array(Movie.all)
      expect(response).to render_template('index')
    end
  end
end
