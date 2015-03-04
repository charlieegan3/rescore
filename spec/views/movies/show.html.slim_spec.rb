require 'rails_helper'

RSpec.describe 'movies/show', :type => :view do
  describe 'favorites' do
    before do
      @movie = assign(:movie, create(:movie))
      @user = create(:user, screen_name: 'bob')
      allow(view).to receive(:current_user).and_return(@user)
      FactoryGirl::create(:review_count_statistic)
      FactoryGirl::create(:people_count_statistic)
      FactoryGirl::create(:topic_sentiments_statistic)
      FactoryGirl::create(:topic_counts_statistic)
      FactoryGirl::create(:sentiment_variation_statistic)
    end

    it 'show favorite button to authenticated users' do
      render
      expect(rendered).to have_css '.fi-heart.inactive'
    end

    it 'show favorite button to authenticated users' do
      allow(view).to receive(:current_user).and_return(nil)
      render
      expect(rendered).to_not have_css '.fi-heart'
    end

    it 'show unfavorite if movie is a user favorite' do
      favorite = create(:favorite, user: @user, movie: @movie)
      render
      expect(rendered).to have_css '.fi-heart.active'
    end
  end
end
