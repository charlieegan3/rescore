class Review
  attr_accessor :text, :sentences, :film_name
  def initialize(text, film_name=nil, other_facts_we_can_ask_the_user='any?')
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
  
  def guess_film_name_from_text
    @film_name = MODULENAME.get_title(review)
  end
  
  def populate_related_people
    @related_people = [{name: 'charlie', role: 'gay frodo' || 'director'}]
  end
  
  def apply_people_tags
    @sentences.map { |sentence| sentence.apply_factor_tags }
  end
  
  def extract_sentences
    @text.split('.').each_with_index {|v, i| @sentences << Sentence.new(i, v)}
  end
  
  def include_cleaned_sentences
    @sentences.map { |sentence| sentence.set_cleaned_text }
  end
  
  def evaluate_sentiment
    @sentences.map { |sentence| sentence.evaluate_sentiment }
  end
  
  def apply_factor_tags
    @sentences.map { |sentence| sentence.apply_factor_tags }
  end
  
  def to_hash
    {text: @text[0..25], sentences: @sentences.map { |sentence| sentence.to_hash } }
  end
end
