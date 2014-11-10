require 'ots'

module Context
  CONTEXTS = {
    editing: ['editing', 'post', 'production', 'effects'],
    sound: ['sound', 'music', 'surround', 'dolby', 'ears', 'audio', 'effects', 'sounds', 'score'],
    plot: ['story', 'plot', 'tale', 'narrative', 'characters', 'character', 'journey', 'narration', 'persona'],
    dialog: ['dialog', 'lines', 'speech', 'discussion', 'conversation', 'language', 'spoken', 'delivery', 'discussion'],
    cast: ['acting', 'cast', 'performance', 'portrayal', 'depiction', 'characterization', 'impersonation', 'role', 'persona'],
    vision: ['visuals', 'vision', 'screen', 'CGI', '3D','graphics', 'visual', 'eyes', 'spectacle', 'special', 'effects', 'beautiful', 'graphic']
  }

  def Context.tags(keywords, context)
    context & keywords
  end

  def Context.tag_sentence(sentence)
    sentence_tags = {}
    keywords = OTS.parse(sentence).keywords

    CONTEXTS.each do |k,v|
      t = tags(keywords, v)
      sentence_tags[k] = t unless t.empty?
    end

    sentence_tags
  end
end
