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

  def collect_reviews
    sleep 1
    update_attribute(:diagnostics, {step: 1, time: Time.new})
    sleep 1
    update_attribute(:diagnostics, {step: 2, time: Time.new})
    sleep 1
    update_attribute(:diagnostics, {step: 3, time: Time.new})

    update_attribute(:reviews, {done: 'done'})
  end
  handle_asynchronously :collect_reviews
end
