module Utils
  def Utils.get_indexes(sentence, key)
    indexes = []
    original = sentence.dup
    while 1
      i = sentence.index(key)
      if i != nil
        indexes.push(i + (original.length - sentence.length))
        sentence[i..i + (key.length-1)] = ''
      else
        break
      end
    end
      
    return indexes
  end
end
