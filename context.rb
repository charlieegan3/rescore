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

  def Context.tag_sentences(cleaned_sentences)
    tags_for_sentences = []
    cleaned_sentences.each do |sentence|
      sentence_tags = {}
      keywords = OTS.parse(sentence).keywords

      CONTEXTS.each do |k,v|
        t = tags(keywords, v)
        sentence_tags[k] = t unless t.empty?
      end
      tags_for_sentences << sentence_tags
    end
    tags_for_sentences
  end
end
