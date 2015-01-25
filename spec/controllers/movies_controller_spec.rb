require 'rails_helper'

RSpec.describe MoviesController, :type => :controller do
  describe 'index' do
    it 'builds a list of movies' do
      movie = Movie.create(title: 'Lord of the Rings')
      get :index
      expect(response).to render_template('index')
      expect(assigns(:movies)).to match_array([movie])
    end
  end
end
