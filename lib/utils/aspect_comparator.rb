class AspectComparator
  def initialize(annotated_sentence, computed_sentence)
    @annotated_sentence = annotated_sentence
    @computed_sentence = computed_sentence
  end

  def compare
    annotated_aspects = aspects_from_annotation(@annotated_sentence)
    computed_aspects = aspects_from_computed(@computed_sentence)
    annotated_aspects.delete('movie')
    scores = hits(annotated_aspects, computed_aspects)
    {
      annotated_aspects: annotated_aspects,
      computed_aspects: computed_aspects,
      scores: scores
    }
  end

  private
    def aspects_from_annotation(annotation)
      Hash[
        annotation['aspects'].map { |key, value|
          [key, {score: value['score'].to_i,
            justification: value['justification'],
            words: value['words']}
          ]
        }
      ]
    end

    def aspects_from_computed(sentence)
      Hash[sentence[:context_tags].keys.map {|key| [key.to_s, {score: sentence[:sentiment]}] }]
    end

    def hits(expected, calculated)
      correct = expected.keys - (expected.keys - calculated.keys)
      wrong = calculated.keys - expected.keys

      sentiment_delta = 0
      correct.map { |aspect| sentiment_delta += (expected[aspect][:score] - calculated[aspect][:score]).abs }

      {correct: correct.size, wrong: wrong.size, delta: sentiment_delta}
    end
end
