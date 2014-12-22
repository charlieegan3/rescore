module Utils
  def Utils.get_indexes(sentence, key)
    indexes = []
    original = sentence.dup
    while 1
      if sentence.index(key) != nil
        indexes.push(sentence.index(key) + (original.length - sentence.length))
        sentence[sentence.index(key)..sentence.index(key) + (key.length-1)] = ''
      else
        break
      end
    end
      
    return indexes
  end
end
