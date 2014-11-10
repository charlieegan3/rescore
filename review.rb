#WARNING, there is a conflict in sentiment_lib and engtagger that I'm silencing here
$VERBOSE = nil

require_relative 'modules/splitter'
require_relative 'modules/sentiment'
require_relative 'modules/context'
require_relative 'modules/noun_phrases'

class Review
  attr_accessor :text, :sentences
  def initialize(text)
    @text = text
    @sentences = []
  end

  def build_all
    extract_sentences
    include_cleaned_sentences
    evaluate_sentiment
    apply_factor_tags
    apply_people_tags
  end

  def extract_sentences
    @sentences = Splitter.punkt_extract_sentences(text)
  end

  def include_cleaned_sentences
    @sentences.map { |sentence| sentence[:clean_text] = sentence[:text].downcase.split(/\W*\s+\W*/).join(" ") }
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

  # UNIMPLEMENTED
  def guess_film_name_from_text
    @film_name = MODULENAME.get_title(review)
  end

  def populate_related_people
    @related_people = [{name: 'charlie', role: 'gay frodo' || 'director'}]
  end

  def apply_people_tags
    @sentences.map { |sentence| sentence.apply_factor_tags }
  end


  def to_hash
    {text: @text[0..25], sentences: @sentences.map { |sentence| sentence.to_hash } }
  end
end
