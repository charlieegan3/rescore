class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie

  validates :movie_id, uniqueness: { scope: :user_id }
end
