class RescoreReview
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
    apply_people_tags
    get_emphasis
  end

  def time_all
    start = Time.now
    if Language.check_language(self.text)

      times = {      :extract_sentences => 0,
      :include_cleaned_sentences => 0,
      :evaluate_sentiment => 0,
      :apply_context_tags => 0,
      :apply_noun_phrases => 0,
      :guess_film_name_from_text => 0,
      :populate_related_people => 0,
      :apply_people_tags => 0,
      :get_emphasis => 0
    }

      extract_sentences
      temp = Time.now - start
      times[:extract_sentences] = temp

      include_cleaned_sentences
      temp = Time.now - start
      times[:include_cleaned_sentences] = temp

      evaluate_sentiment
      temp = Time.now - start
      times[:evaluate_sentiment] = temp

      apply_context_tags
      temp = Time.now - start
      times[:apply_context_tags] = temp

      apply_noun_phrases
      temp = Time.now - start
      times[:apply_noun_phrases] = temp

      guess_film_name_from_text
      temp = Time.now - start
      times[:guess_film_name_from_text] = temp

      populate_related_people
      temp = Time.now - start
      times[:populate_related_people] = temp

      apply_people_tags
      temp = Time.now - start
      times[:apply_people_tags] = temp

      get_emphasis
      temp = Time.now - start
      times[:get_emphasis] = temp

      return times
    else
      puts "Failed to analyse review: language was not English."
      return 0
    end
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
    @sentences.map { |sentence| sentence[:context_tags], sentence[:context_indexes] = Context.tag_sentence(sentence[:clean_text]) }
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
      #puts 'A film name was not found'
      return
    end
    @related_people = MovieInfo.get_people(@film_name)
  end

  def apply_people_tags
    if @related_people.nil?
      #puts 'No related people have been assigned'
      return
    end
    previous_name = nil
    @sentences.each do |sentence|
      people = People.tag_sentence(sentence[:text], @related_people[:cast], @related_people[:director], previous_name, true)
      sentence[:people_tags], previous_name, sentence[:people_indexes] = people
      sentence[:people_indexes] = sentence[:people_indexes].to_a.reject! {|x| x[1].empty?}
    end
  end

  def get_emphasis
    @sentences.map{ |sentence| sentence[:emphasis] = Emphasis.score(sentence[:text]) }
  end
end
