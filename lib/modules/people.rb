require_relative 'utils'

module People
  def People.tag_sentence(sentence, cast, director, prev_name, actors_only)

    #puts sentence
    sentence = sentence.to_ascii # Get rid of accented letters etc.
    names = [] # The cast members detected in this sentence.
    people_indexes = {} # where in the sentence the person is mentioned.

    # initialize director hash entry.
    if director.class.method_defined?(name)
      people_indexes[director.name] = []
    end

    # Tag sentence
    if !cast.empty?
      cast.each do |c|
        people_indexes[c[:name]] = []
        if sentence.include?(c[:name])
          people_indexes[c[:name]] = Utils.get_indexes(sentence, c[:name])
          names.push(c[:name]) if !names.include?(c[:name])
        end

        if actors_only == false
          c[:characters].each do |ch|
            if sentence.include?(ch)
              people_indexes[ch.name] = Utils.get_indexes(sentence, ch.name)
              names.push(ch) if !names.include?(ch)
            end
          end
        end
      end
    end

    # if director.class.method_defined?(name)
    #   if sentence.include?(director.name)
    #     names.push(director.name) if !names.include?(director.name)
    #   end
    # end

    # Check for mentions using pronouns.
    if names.empty?
      pronouns = ["He", "he", "Him", "him", "His", "his", "She", "she", "Her", "her"]
        sentence.split.to_a.each do |word|
          if pronouns.include?(word) && prev_name != nil
            names.push(prev_name)
            break
          end
        end
    end

    prev_name = names.last

    return names, prev_name, people_indexes
  end

end
