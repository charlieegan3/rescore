require 'rails_helper'
require 'spec_helper'

RSpec.describe MoviesController, :type => :controller do
  before(:each) do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(ADMIN_USERNAME, ADMIN_PASSWORD)
  end

  describe 'index' do
    it 'builds a list of movies' do
      movie = FactoryGirl::create(:movie)
      get :index
      expect(assigns(:movies)).to match_array([movie])
      expect(response).to render_template('index')
    end
  end

  describe 'compare' do
    it 'redirects if there are less than two movies' do
      get :compare
      expect(current_url).to eql('')
    end

    it 'displays properly if there are at least two movies' do
      FactoryGirl::create(:movie, title: "The Hobbit")
      FactoryGirl::create(:movie, title: "The Fellowship of the Rings")
      get :compare
      expect(response).to render_template('choose_compare')
    end
  end
end
