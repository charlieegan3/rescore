require 'rails_helper'

RSpec.describe Favorite, :type => :model do
  it { should validate_uniqueness_of(:movie_id).scoped_to(:user_id) }
end
