require 'rails_helper'

RSpec.describe "movies", :type => :view do  
  before(:each) do
    movie = FactoryGirl::create(:movie)
  end
  describe 'movies index' do
    it 'lists the existing films' do
      visit ('/movies')
      expect(page).to have_content 'Gladiator'
    end
  end
end
