require 'rails_helper'
require 'spec_helper'

RSpec.describe MoviesController, :type => :controller do

  describe 'index' do
    it 'builds a list of movies' do
      movie = FactoryGirl::create(:movie) # before(:each) doesn't put 'movie' in scope here...
      get :index
      expect(response).to render_template('index')
      expect(assigns(:movies)).to match_array([movie])
    end
  end

  describe 'compare' do
    it 'redirects if there are less than two movies' do
      get :compare
      expect(response).to render_template('/')
    end

    it 'displays properly if there are at least two movies' do
      movie2 = FactoryGirl::create(:movie, title: "The Hobbit")
      get :compare
      expect(response).to render_template('movies/choose_compare')
    end
  end
end
