require 'ots'
require_relative 'utils'

module Context
  CONTEXTS = {
    editing: ['editing', 'post', 'production', 'effects'],
    sound: ['sound', 'music', 'surround', 'dolby', 'ears', 'audio', 'effects', 'sounds', 'score'],
    plot: ['story', 'plot', 'tale', 'narrative', 'characters', 'character', 'journey', 'narration', 'persona'],
    dialog: ['dialog', 'lines', 'speech', 'discussion', 'conversation', 'language', 'spoken', 'delivery', 'discussion'],
    cast: [acting:[5], 'cast', 'performance', 'portrayal', 'depiction', 'characterization', 'impersonation', 'role', 'persona'],
    vision: ['visuals', 'vision', 'screen', 'CGI', '3D','graphics', 'visual', 'eyes', 'spectacle', 'special', 'effects', 'beautiful', 'graphic']
  }

  def Context.tags(keywords, context)
    return context & keywords
  end

  def Context.tag_sentence(sentence)
    sentence_tags = {}
    sentence_tag_indexes = {}
    #keywords = OTS.parse(sentence).keywords
    keywords = sentence.downcase.gsub(/\W/, ' ').split(/\s+/) # temporary solution, faster than OTS.

    CONTEXTS.each do |k,v|
      t = tags(keywords, v)
      sentence_tags[k] = t unless t.empty?

      if !t.empty?
        t.each do |x|
          sentence_tag_indexes[x] = []
        end
      end
    end

    sentence_tags.each do |k, v|
      v.each do |word|
        sentence_tag_indexes[word] = Utils.get_indexes(sentence, word)
      end
    end

    return sentence_tags, sentence_tag_indexes
  end
end
