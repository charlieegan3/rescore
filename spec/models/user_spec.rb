require "rails_helper"

RSpec.describe User, :type => :model do
  it { should validate_uniqueness_of(:screen_name) }
  it { should have_many(:favorites) }

  it 'assigns a user details' do
    user = User.create_with_omniauth(mock_auth_hash)
    expect(user.name).to eq('Mock User')
    expect(user.screen_name).to eq('mockuser')
  end
end
