class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])

    @ratings_chart = LazyHighCharts::HighChart.new('column') do |f|
      f.series(name: 'Ratings', data: @movie.rating_distribution)
      f.options[:chart][:defaultSeriesType] = 'column'
      f.options[:chart][:width] = '200'
      f.options[:chart][:height] = '150'
      f.options[:legend][:enabled] = false
    end

    @sample_size = 5
    @sample_size = @movie.reviews.size if params[:all]
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

  def populate_source_links
    @movie = Movie.find(params[:id])
    @movie.populate_source_links
    redirect_to movie_path(@movie)
  end

  def populate_related_people
    @movie = Movie.find(params[:id])
    @movie.populate_related_people
    redirect_to movie_path(@movie)
  end

  def collect
    @movie = Movie.find(params[:id])
    @movie.collect_reviews
    @movie.update_attribute(:status, 'Waiting...')
    redirect_to movie_path(@movie)
  end

  private
    def movie_params
      params.require(:movie).permit(:title, :page_depth,:imdb_link, :amazon_link, :metacritic_link, :rotten_tomatoes_link)
    end
end
