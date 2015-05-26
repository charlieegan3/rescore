class SourceSearcher
  def initialize(title, year)
    @title = title
    @year = year.to_s
    GoogleAjax.referer = ENV['GOOGLE_AJAX_REFERRER']
  end

  def links
    {
      metacritic_link: metacritic_link,
      amazon_link: amazon_link,
      imdb_link: imdb_link,
      rotten_tomatoes_link: rotten_tomatoes_link
    }
  end

  def metacritic_link
    top_hit('www.metacritic.com/movie/')
  end

  def amazon_link
    top_hit('www.amazon.com dvd reviews')
  end

  def imdb_link
    top_hit('www.imdb.com/title/')
  end

  def rotten_tomatoes_link
    top_hit('www.rottentomatoes.com/m/')
  end

  private
    def top_hit(domain)
      results(domain)[:results][0][:unescaped_url]
    end

    def results(domain)
      GoogleAjax::Search.web(@title + " site:#{domain} " + @year)
    end
end
