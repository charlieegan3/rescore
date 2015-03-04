class FavoritesController < ApplicationController
  def set
    favorite = Favorite.where(favorite_params[:favorite]).first
    if favorite
      favorite.delete
    else
      Favorite.create!(favorite_params)
    end
    redirect_to movie_path(Movie.find(params[:favorite][:movie_id]))
  end

  private
    def favorite_params
      params.require(:favorite).permit(:movie_id).merge({user: current_user})
    end
end
