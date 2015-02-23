class SourceSearcher
  def initialize(title, year)
    @title = title
    @year = year.to_s
    GoogleAjax.referer = 'www.rescore.io'
  end

  def metacritic_link
    top_hit('www.rottentomatoes.com/m/')
  end

  def amazon_link
    top_hit('www.imdb.com/title/')
  end

  def imdb_link
    top_hit('www.amazon.com dvd reviews')
  end

  def rotten_tomatoes_link
    top_hit('www.metacritic.com/movie/')
  end

  private
    def top_hit(domain)
      results(domain)[:results][0][:unescaped_url]
    end

    def results(domain)
      GoogleAjax::Search.web(@title + " site:#{domain} " + @year)
    end
end
