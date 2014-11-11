#WARNING, there is a conflict in sentiment_lib and engtagger that I'm silencing here
$VERBOSE = nil

require 'pry'
require_relative 'modules/splitter'
require_relative 'modules/sentiment'
require_relative 'modules/context'
require_relative 'modules/noun_phrases'
require_relative 'modules/movie_info'
require_relative 'modules/people'

class Review
  attr_accessor :text, :sentences, :film_name, :related_people
  def initialize(text)
    @text = text
    @sentences = []
  end

  def build_all
    extract_sentences
    include_cleaned_sentences
    evaluate_sentiment
    apply_context_tags
    apply_noun_phrases
    guess_film_name_from_text
    populate_related_people
    apply_people_tags
  end

  def extract_sentences
    @sentences = Splitter.punkt_extract_sentences(text)
  end

  def include_cleaned_sentences
    @sentences.map { |sentence| sentence[:clean_text] = sentence[:text].downcase.split(/\W*\s+\W*/).join(" ").strip }
  end

  def evaluate_sentiment
    sentiment_analyzer = Sentiment::SentimentAnalyzer.new
    @sentences.map { |sentence| sentence[:sentiment] = sentiment_analyzer.get_sentiment(sentence[:clean_text]) }
  end

  def apply_context_tags
    @sentences.map { |sentence| sentence[:context_tags] = Context.tag_sentence(sentence[:clean_text]) }
  end

  def apply_noun_phrases
    extracter = NounPhrases::Extractor.new
    @sentences.map { |sentence| sentence[:noun_phrases] = extracter.extract_noun_phrases(sentence[:clean_text]) }
  end

  def guess_film_name_from_text
    @film_name = MovieInfo.get_title(text)
  end

  def populate_related_people
    if @film_name.nil?
      puts 'A film name was not found'
      return
    end
    @related_people = MovieInfo.get_people(@film_name)
  end

  def apply_people_tags
    if @related_people.nil?
      puts 'No related people have been assigned'
      return
    end
    previous_name = nil
    @sentences.each do |sentence|
      people = People.tag_sentence(sentence[:text], @related_people[:cast], @related_people[:director], previous_name, true)
      sentence[:people_tags], previous_name = people
    end
  end
end
