require 'rails_helper'

describe 'the signin process', :type => :feature do
  it 'can sign in user with Twitter account' do
    FactoryGirl::create(:movie)

    visit '/'
    expect(page).to have_content('Sign in with Twitter')
    mock_auth_hash
    click_link 'Sign in with Twitter'
    expect(page).to have_content('Sign Out')
  end
end
