class AspectComparator
  def initialize(annotated_sentence, computed_sentence)
    @annotated_sentence = annotated_sentence
    @computed_sentence = computed_sentence
  end

  def compare
    annotated_aspects = aspects_from_annotation(@annotated_sentence)
    computed_aspects = aspects_from_computed(@computed_sentence)
    scores = hits(annotated_aspects, computed_aspects)
    {
      annotated_aspects: annotated_aspects,
      computed_aspects: computed_aspects,
      scores: scores
    }
  end

  private
    def aspects_from_annotation(annotation)
      Hash[annotation['aspects'].map { |key, value| [key, value['score'].to_i] }]
    end

    def aspects_from_computed(sentence)
      score = normalise(sentence[:sentiment][:corrected_average])
      Hash[sentence[:context_tags].keys.map {|key| [key.to_s, score] }]
    end

    def hits(expected, calculated)
      correct = expected.keys - (expected.keys - calculated.keys)
      wrong = calculated.keys - expected.keys

      sentiment_delta = 0
      correct.map { |aspect| sentiment_delta += (expected[aspect] - calculated[aspect]).abs }

      {correct: correct.size, wrong: wrong.size, delta: sentiment_delta}
    end

    def normalise(decimal)
      ((((decimal * 10) / 5).round * 5).to_f / 5).to_i
    end
end
