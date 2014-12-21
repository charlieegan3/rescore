class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.create(movie_params)
    redirect_to movie_path(@movie)
  end

  def update
    @movie = Movie.find(params[:id])
    @movie.update_attributes(movie_params)
    redirect_to movie_path(@movie)
  end

  def destroy
    Movie.find(params[:id]).delete
    redirect_to movies_path
  end

  def populate
    @movie = Movie.find(params[:id])
    @movie.populate_source_links
    redirect_to movie_path(@movie)
  end

  def collect
    @movie = Movie.find(params[:id])
    @movie.collect_reviews
    redirect_to movie_path(@movie)
  end

  private
    def movie_params
      params.require(:movie).permit(:title, :page_depth,:imdb_link, :amazon_link, :metacritic_link, :rotten_tomatoes_link)
    end
end
