class MetadataController < ApplicationController
  def search
    bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
    @movies = []
    @movies = bf.movies.search_by_name(params[:query]) if params[:query]
  end
end
