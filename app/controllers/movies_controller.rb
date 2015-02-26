class MoviesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "1234qwer", :except => [:show, :search_by_title, :compare]

  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    @summary = {:review_count => "", :topic_counts => "", :topic_sentiments => "", :people_count => ""}
    @indicators = {:review_count => false, :topic_counts => false, :topic_sentiments => false, :people_count => false}

    if @movie.reviews.size >= Statistic.find_by_identifier('review_count').value[:count] / Movie.count
      @summary[:review_count] = "#{@movie.title} has an above average review count."
      @indicators[:review_count] = true
    else
      @summary[:review_count] = "#{@movie.title} has a below average review count."
    end

    if @movie.related_people.size >= Statistic.find_by_identifier('people_count').value[:count] / Movie.count
      @summary[:people_count] = "#{@movie.title} has an above average number of cast members."
      @indicators[:people_count] = true
    else
      @summary[:people_count] = "#{@movie.title} has a below average number of cast members."
    end

    if @movie.stats[:topic_counts].values.sum >= Statistic.find_by_identifier('topic_counts').value.values.sum / Movie.count
      @summary[:topic_counts] = "#{@movie.title} has an above average number of topics."
      @indicators[:topic_counts] = true
    else
      @summary[:topic_counts] = "#{@movie.title} has a below average number of topics."
    end

    if @movie.sentiment[:topics].values.sum >= Statistic.find_by_identifier('topic_sentiments').value.values.sum / Movie.count
      @summary[:topic_sentiments] = "#{@movie.title} has an above average overall topic sentiment."
      @indicators[:topic_sentiments] = true
    else
      @summary[:topic_sentiments] = "#{@movie.title} has a below average overall topic sentiment."
    end

    if @movie.stats.nil?
      flash[:alert] = "This movie's information is not yet complete. Please try again later"
      redirect_to :root
    end
  end

  def compare
    if Movie.count <= 1
      flash[:alert] = "Not enough movies to compare!"
      return redirect_to :root
    elsif params[:m1] && params[:m2]
      @movie_1 = Movie.fast_find(params[:m1])
      @movie_2 = Movie.fast_find(params[:m2])
      return render 'compare'
    else
      @options = Movie.all.pluck(:title, :id).shuffle
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
