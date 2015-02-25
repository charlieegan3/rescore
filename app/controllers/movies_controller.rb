class MoviesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "1234qwer", :except => [:index, :show, :search_by_title, :compare]

  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.fast_find(params[:id])

    if @movie.stats.nil?
      flash[:alert] = "This movie's information is not yet complete. Please try again later"
      redirect_to :root
    end
  end

  def compare
    if params[:filmone] && params[:filmtwo]
      if params[:filmone] != params[:filmtwo]
        @movie_one = Movie.fast_find(params[:filmone][:id])
        @movie_two = Movie.fast_find(params[:filmtwo][:id])
        render 'compare'
      else
        flash[:alert] = 'Please choose different films to compare.'
        redirect_to compare_movies_path
      end
    else
      render 'choose_compare'
    end
  end

  def manage
    @movie = Movie.find(params[:id])

    @cast_count = 3
    @cast_count = 1000 if params[:all_cast]

    @review_count = 5
    @review_count = 10000 if params[:all_reviews]
  end

  def search_by_title
    @movies = Movie.where("title ILIKE ?", "%#{params[:query]}%")
  end

  def new
    @movie = Movie.new(page_depth: 1)
  end

  def new_from_lookup
    bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
    @movies = []
    @movies = bf.movies.search_by_name(params[:query], 3) if params[:query]
    @movies.each do |movie|
      movie.genres = bf.movies.search_by_id(movie.id).genres
    end
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    params = movie_params
    params[:genres] = params[:genres].split(', ')
    if Movie.exists?(title: params[:title])
      flash[:alert] = "This movie already exists."
      redirect_to new_movie_from_lookup_path
    else
      @movie = Movie.create(params)
      redirect_to manage_movie_path(@movie)
    end
  end

  def update
    @movie = Movie.find(params[:id])
    params = movie_params
    params[:genres] = params[:genres].split(', ')
    @movie.update_attributes(params)
    redirect_to manage_movie_path(@movie)
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
    redirect_to manage_movie_path(@movie)
  end

  def populate_related_people
    @movie = Movie.find(params[:id])
    @movie.populate_related_people
    redirect_to manage_movie_path(@movie)
  end

  def build_summary
    @movie = Movie.find(params[:id])
    @movie.build_summary
    @movie.update_attribute(:task, 'summary')
    @movie.update_attribute(:status, '0%')
    redirect_to manage_movie_path(@movie)
  end

  def collect
    @movie = Movie.find(params[:id])
    @movie.collect_reviews
    @movie.update_attribute(:task, 'collect')
    @movie.update_attribute(:status, '0%')
    redirect_to manage_movie_path(@movie)
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
        :year,
        :genres
      )
    end
end
