class RescoreReview
  attr_accessor :text, :sentences, :film_name, :related_people
  def initialize(text, related_people)
    @text = text
    @sentences = []
    @related_people = related_people
  end

  def build_all
    extract_sentences
    include_cleaned_sentences
    evaluate_sentiment
    apply_context_tags
    #apply_noun_phrases   -> Not being used currently (will be in future).
    apply_people_tags
    get_emphasis
  end

  def extract_sentences
    @sentences = []
    @sentences = Splitter.punkt_extract_sentences(text) unless text.length < 100
  end

  def include_cleaned_sentences
    @sentences.map { |sentence| sentence[:clean_text] = sentence[:text].downcase.split(/\W*\s+\W*/).join(" ").strip }
  end

  def evaluate_sentiment
    sentiment_analyzer = Sentiment::SentimentAnalyzer.new
    @sentences.map { |sentence| sentence[:sentiment] = sentiment_analyzer.get_sentiment(sentence[:clean_text]) }
  end

  def apply_context_tags
    @sentences.map { |sentence| sentence[:context_tags], sentence[:context_indexes] = Context.tag_sentence(sentence[:clean_text]) }
  end

  def apply_noun_phrases
    extracter = NounPhrases::Extractor.new
    @sentences.map { |sentence| sentence[:noun_phrases] = extracter.extract_noun_phrases(sentence[:clean_text]) }
  end

  def apply_people_tags
    return if @related_people.nil?
    previous_name = nil
    @sentences.each do |sentence|
      people = People.tag_sentence(sentence[:text], @related_people[:cast], previous_name)
      sentence[:people_tags], previous_name, sentence[:people_indexes] = people
      sentence[:people_indexes] = sentence[:people_indexes].to_a.reject! {|x| x[1].empty?}
    end
  end

  def get_emphasis
    @sentences.map{ |sentence| sentence[:emphasis] = Emphasis.score(sentence[:text]) }
  end
end
