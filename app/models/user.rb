class User < ActiveRecord::Base
  validates :screen_name, uniqueness: true

  def self.create_with_omniauth(auth)
    user = User.find_by_screen_name(auth['extra']['raw_info']['screen_name'])
    return user if user.present?
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name']
      user.profile_picture = auth['info']['image']
      user.screen_name = auth['extra']['raw_info']['screen_name']
      user.time_zone = auth['extra']['raw_info']['utc_offset']
    end
  end
end
