class Movie < ActiveRecord::Base
  serialize :diagnostics, Hash
  serialize :reviews, Hash

  def populate_source_links
    GoogleAjax.referrer = "www.resco.re"
    update_attribute(:metacritic_link,
      GoogleAjax::Search.web(title + " metacritic")[:results][0][:unescaped_url])
    update_attribute(:amazon_link,
      GoogleAjax::Search.web(title + " amazon.com customer reviews")[:results][0][:unescaped_url])
    update_attribute(:imdb_link,
      GoogleAjax::Search.web(title + " imdb")[:results][0][:unescaped_url])
    update_attribute(:rotten_tomatoes_link,
      GoogleAjax::Search.web(title + " rotten tomatoes")[:results][0][:unescaped_url])
  end
end
