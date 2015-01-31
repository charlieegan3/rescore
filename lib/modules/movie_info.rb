module MovieInfo

  # | ------------------------------------------------------------------------
  # | ABOUT:
  # |
  # | get_title() finds the title of a film, given a review.
  # | get_people() finds the cast list and director for a film, given a title.
  # | ------------------------------------------------------------------------

  GoogleAjax.referrer = "hey"

  def MovieInfo.get_people(title)
    begin
      bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
      query = bf.movies.search_by_name(title[0..15]) # Try to cut out irrelevant bits of string.

      cast = query[0].full_cast
      director = query[0].director
      #reviews = query[0].reviews

    rescue NoMethodError
      return {:cast => [], :director => []}
    end

    return {:cast => cast, :director => director}
  end

end
