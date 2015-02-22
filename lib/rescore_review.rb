class RescoreReview
  attr_accessor :text, :sentences, :film_name, :related_people
  def initialize(text, related_people)
    @text = text
    @sentences = []
    @related_people = related_people
  end

  def build_all
    @sentences = Splitter.punkt_extract_sentences(text) unless text.length < 100

    previous_name = nil
    @sentences.each do |sentence|
      sentence[:clean_text] = sentence[:text].downcase.split(/\W*\s+\W*/).join(" ").strip
      sentence[:sentiment] = Sentiment.evaluate_sentence(sentence[:clean_text])
      sentence[:context_tags] = Context.tag_sentence(sentence[:clean_text])
      sentence[:emphasis] = Emphasis.score(sentence[:text])

      next if @related_people.nil?
      people = People.tag_sentence(sentence[:text], @related_people, previous_name)
      sentence[:people_tags], previous_name, sentence[:people_indexes] = people
      sentence[:people_indexes] = sentence[:people_indexes].to_a.reject! {|x| x[1].empty?}
    end
  end
end
