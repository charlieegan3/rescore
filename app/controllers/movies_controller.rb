class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])

    @cast_count = 3
    @cast_count = 1000 if params[:all_cast]

    @review_count = 5
    @review_count = 10000 if params[:all_reviews]
  end

  def new
    @movie = Movie.new(page_depth: 1)
  end

  def new_from_lookup
    bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
    @movies = []
    @movies = bf.movies.search_by_name(params[:query], 50) if params[:query]
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

  def status
    @movie = Movie.find(params[:id])
    render layout: false
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

  def build_summary
    @movie = Movie.find(params[:id])
    @movie.build_summary
    @movie.update_attribute(:task, 'summary')
    @movie.update_attribute(:status, '0%')
    redirect_to movie_path(@movie)
  end

  def collect
    @movie = Movie.find(params[:id])
    @movie.collect_reviews
    @movie.update_attribute(:task, 'collect')
    @movie.update_attribute(:status, '0%')
    redirect_to movie_path(@movie)
  end

  private
    def movie_params
      params.require(:movie).permit(
        :title,
        :page_depth,
        :imdb_link,
        :amazon_link,
        :metacritic_link,
        :rotten_tomatoes_link,
        :rotten_tomatoes_id,
        :image_url,
        :year
      )
    end
end
