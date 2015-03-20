require 'rails_helper'

RSpec.describe Statistic, :type => :model do
  it { should validate_uniqueness_of(:identifier) }
end
