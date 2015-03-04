FactoryGirl.define do
  factory :user do
    provider 'twitter'
    uid '12345'
    name 'Charlie Egan'
    screen_name 'charlieegan3'
    profile_picture 'http://www.example.com/image.jpg'
    time_zone '0'
  end
end
