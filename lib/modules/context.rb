require 'ots'
require_relative 'utils'

module Context
  CONTEXTS = {
    editing: {'editing' => 100, 'post' => 20, 'production' => 50, 'effects' => 70},
    sound: {'sound' => 100, 'music' => 100, 'surround' => 80, 'dolby' => 100, 'ears' => 20, 'audio' => 100, 'sounds' => 100, 'score' => 10},
    plot: {'story' => 100, 'plot' => 100, 'tale' => 30, 'narrative' => 80, 'characters' => 50, 'character' => 50, 'journey' => 30, 'narration' => 80, 'persona' => 20},
    dialog: {'dialog' => 100, 'lines' => 70, 'speech' => 100, 'discussion' => 80, 'conversation' => 80, 'language' => 70, 'spoken' => 90, 'delivery' => 50},
    cast: {'acting' => 100, 'cast' => 100, 'performance' => 90, 'portrayal' => 90, 'depiction' => 90, 'characterization' => 90, 'impersonation' => 90, 'role' => 70, 'persona' => 50},
    vision: {'visuals' => 100, 'vision' => 90, 'imax' => 100, 'lifelike' => 80, 'screen' => 70, 'cgi' => 100, '3d' => 100, 'graphics' => 100, 'blurry' => 80, 'visual' => 100, 'eyes' => 30, 'spectacle' => 60, 'beautiful' => 20, 'graphic' => 90, 'colour' => 90, 'color' => 90, 'designs' => 8}
  }

  def Context.tag_sentence(sentence)
    sentence_tags = Hash.new([])

    keywords = sentence.gsub(/\W/, ' ').split(/\s+/).
      select { |word| word.length > 3 }

    CONTEXTS.each do |context, terms|
      keywords.each do |keyword|
        if terms.keys.include? keyword
          sentence_tags[context] += [terms[keyword]]
        end
      end
    end

    sentence_tags.map { |k, v| sentence_tags[k] = v.reduce(:+) / sentence_tags.size }

    return sentence_tags
  end
end
