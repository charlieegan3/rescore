module People
  def People.tag_sentence(sentence, cast, director, prev_name, actors_only)
    # puts ("#"*15+" Sentence "+"#"*15).colorize(:blue)
    puts sentence
    sentence = sentence.to_ascii # Get rid of accented letters etc.
    names = [] # The cast members detected in this sentence.

    cast.each do |c|
      if sentence.include?(c.name)
        names.push(c.name) if !names.include?(c.name)
      end

      c.characters.each do |ch|
        if sentence.include?(ch)
          names.push(c.name) if !names.include?(c.name) && actors_only == true
          names.push(ch) if !names.include?(ch) && actors_only == false
        end
      end
    end

    if sentence.include?(director.name)
      names.push(director.name) if !names.include?(director.name)
    end

    if names.empty?
      pronouns = ["He", "he", "Him", "him", "His", "his", "She", "she", "Her", "her"]
        sentence.split.to_a.each do |word|
          if pronouns.include?(word) && prev_name != nil
            names.push(prev_name + "(FROM PREVIOUS REFERENCE)") if !names.include?(prev_name + "(FROM PREVIOUS REFERENCE)")
          end
        end
    end

    # print "Matches: ".colorize(:red)
    # names.each do |n|
    #   print " #{n}".colorize(:yellow)
    # end
    prev_name = names.last

    return names, prev_name
  end
end
