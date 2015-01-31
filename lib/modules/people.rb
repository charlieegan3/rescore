require_relative 'utils'

module People
  def People.tag_sentence(sentence, cast, prev_name)

    sentence = sentence.to_ascii # Get rid of accented letters etc.
    mentioned_actors = [] # The cast members detected in this sentence.
    people_indexes = {} # where in the sentence the person is mentioned.

    # Tag sentence
    cast.each do |member|
      people_indexes[member[:name]] = []
      if sentence.include?(member[:name])
        people_indexes[member[:name]] = Utils.get_indexes(sentence, member[:name])
        mentioned_actors.push(member[:name]) if !mentioned_actors.include?(member[:name])
      end

      member[:characters].each do |character|
        if sentence.include?(character)
          people_indexes[character] = Utils.get_indexes(sentence, character)
          mentioned_actors.push(character) if !mentioned_actors.include?(character)
        end
      end
    end

    # Check for mentions using pronouns.
    if mentioned_actors.empty? && prev_name != nil
      pronouns = ['he', 'him', 'his', 'she', 'her']
        sentence.downcase.gsub(/\W/, ' ').split(/\s+/).each do |word|
          if pronouns.include?(word)
            mentioned_actors.push(prev_name)
            break
          end
        end
    end

    return mentioned_actors, mentioned_actors.last, people_indexes
  end
end
