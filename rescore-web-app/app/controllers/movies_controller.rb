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
    @sample_size = 1000 if params[:all]

    # this cannot stay here
    @topic_sentiment  = {}
    @movie.reviews.each do |review|
      next if review[:rescore_review].nil?
      review[:rescore_review].each do |sentence|
        sentence[:context_tags].keys.each do |tag|
          p tag
          p @topic_sentiment
          @topic_sentiment[tag] = [] if @topic_sentiment[tag].nil?
          @topic_sentiment[tag] << sentence[:sentiment][:average]
        end
      end
    end
    @topic_sentiment = @topic_sentiment.map {|k,v| [k, v.reduce(:+) / v.size] }
  end

  def new
    @movie = Movie.new(page_depth: 1)
  end

  def new_from_lookup
    bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
    @movies = []
    @movies = bf.movies.search_by_name(params[:query]) if params[:query]
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

  def build_summary
    @movie = Movie.find(params[:id])
    @movie.build_summary
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
      params.require(:movie).permit(
        :title,
        :page_depth,
        :imdb_link,
        :amazon_link,
        :metacritic_link,
        :rotten_tomatoes_link,
        :rotten_tomatoes_id,
        :image_url
      )
    end
end
