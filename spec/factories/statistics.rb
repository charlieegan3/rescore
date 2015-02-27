FactoryGirl.define do
  factory :statistic do
    identifier 'review_count'
    value ({:count => 5})
  end
end
