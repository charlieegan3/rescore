class MoviesController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_USERNAME'], password: ENV['ADMIN_PASSWORD'], except: [:index, :show, :search_by_title, :compare]

  def index
    @movies = Movie.complete.order('created_at DESC')

    respond_to do |format|
      format.html
      format.json { render :json => @movies.select(:id, :title, :image_url, :year, :genres, :slug) }
      format.xml  { render :xml => @movies.select(:id, :title, :image_url, :year, :genres, :slug) }
    end
  end

  def admin
    @movies = Movie.order('created_at DESC')
  end

  def show
    @movie = Movie.find_by_slug(params[:id])

    if @movie.stats.empty?
      flash[:alert] = "This movie's information is not yet complete. Please try again later"
      redirect_to :root
    else
      respond_to do |format|
        format.html
        format.json  { render json: @movie, except: [:id, :page_depth, :rotten_tomatoes_id, :status, :created_at, :updated_at, :task, :complete, :slug]}
        format.xml  { render xml: @movie, except: [:id, :page_depth, :rotten_tomatoes_id, :status, :created_at, :updated_at, :task, :complete, :slug]}
      end
    end
  end

  def manage
    @movie = Movie.find_by_slug(params[:id])

    @cast_count = 3
    @cast_count = 1000 if params[:all_cast]

    @review_count = 5
    @review_count = 10000 if params[:all_reviews]
  end

  def search_by_title
    if params[:query].blank?
      flash[:alert] = "No search content provided."
      redirect_to :root
    else
      @movies = Movie.where("title ILIKE ?", "%#{params[:query]}%")
      return redirect_to movie_path(@movies.first.id) if @movies.length == 1
    end
  end

  def new
    @movie = Movie.new(page_depth: 1)
  end

  def new_from_lookup
    bf = BadFruit.new(ENV['BADFRUIT_KEY'])
    @movies = []
    @movies = bf.movies.search_by_name(params[:query], 3) if params[:query]
    @movies.each do |movie|
      movie.genres = bf.movies.search_by_id(movie.id).genres
    end
  end

  def edit
    @movie = Movie.find_by_slug(params[:id])
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
    @movie = Movie.find_by_slug(params[:id])
    params = movie_params
    params[:genres] = params[:genres].split(', ')
    @movie.update_attributes(params)
    redirect_to manage_movie_path(@movie)
  end

  def destroy
    Movie.find_by_slug(params[:id]).destroy
    redirect_to movie_admin_path
  end

  def status
    @movie = Movie.find_by_slug(params[:id])
    render layout: false
  end

  def build
    @movie = Movie.find_by_slug(params[:id])
    @movie.update_attribute(:status, '0%')
    @movie.build
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
