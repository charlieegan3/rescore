module People
  def People.tag_sentence(sentence, cast, director, prev_name, actors_only)

    puts sentence
    sentence = sentence.to_ascii # Get rid of accented letters etc.
    names = [] # The cast members detected in this sentence.
    people_indexes = {}

    # initialise hash
    if !cast.empty?
      cast.each do |c|
        people_indexes[c.name] = []
      end
    end
    if director
      people_indexes[director.name] = []
    end

    # Tag sentence
    if !cast.empty?
      cast.each do |c|
        if sentence.include?(c.name)
          people_indexes[c.name] = get_indexes(sentence, c.name)
          names.push(c.name) if !names.include?(c.name)
        end
  
        c.characters.each do |ch|
          if sentence.include?(ch)
            people_indexes[c.name] = get_indexes(sentence, ch) if actors_only == true
            people_indexes[ch.name] = get_indexes(sentence, ch.name) if actors_only == false
            names.push(c.name) if !names.include?(c.name) && actors_only == true
            names.push(ch) if !names.include?(ch) && actors_only == false
          end
        end
      end
    end

    if director
      if sentence.include?(director.name)
        names.push(director.name) if !names.include?(director.name)
      end
    end

    if names.empty?
      pronouns = ["He", "he", "Him", "him", "His", "his", "She", "she", "Her", "her"]
        sentence.split.to_a.each do |word|
          if pronouns.include?(word) && prev_name != nil
            names.push(prev_name + "(FROM PREVIOUS REFERENCE)") if !names.include?(prev_name + "(FROM PREVIOUS REFERENCE)")
          end
        end
    end

    prev_name = names.last

    return names, prev_name, people_indexes
  end

  def People.get_indexes(sentence, key) # Tag the indexes of each instance of a word in a sentence.
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
