module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:twitter] = {
      'provider' => 'twitter',
      'uid' => '123545',
      'info' => {
        'name' => 'Mock User',
        'image' => 'mock_user_thumbnail_url'
      },
      'extra' => {
        'raw_info' => {
          'screen_name' => 'mockuser',
          'utc_offset' => 0
        }
      }
    }
  end
end
