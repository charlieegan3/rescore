require 'ots'
require_relative 'utils'

module Context
  CONTEXTS = {
    editing: ['editing', 'post', 'production', 'effects'],
    sound: ['sound', 'music', 'surround', 'dolby', 'ears', 'audio', 'sounds', 'score'],
    plot: ['story', 'plot', 'tale', 'narrative', 'characters', 'character', 'journey', 'narration', 'persona'],
    dialog: ['dialog', 'lines', 'speech', 'discussion', 'conversation', 'language', 'spoken', 'delivery', 'discussion'],
    cast: ['acting', 'cast', 'performance', 'portrayal', 'depiction', 'characterization', 'impersonation', 'role', 'persona'],
    vision: ['visuals', 'vision', 'imax', 'lifelike', 'screen', 'sharper', 'cgi', '3d', 'graphics', 'blurry', 'visual', 'eyes', 'spectacle', 'beautiful', 'graphic', 'colour', 'color', 'designs']
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
    end

    return sentence_tags
  end
end
