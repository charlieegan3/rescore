require_relative 'utils'

module People
  def People.tag_sentence(sentence, people, prev_name)

    sentence = sentence.to_ascii # Get rid of accented letters etc.
    mentioned_people = [] # The cast members detected in this sentence.
    people_indexes = Hash.new([]) # where in the sentence the person is mentioned.

    # Tag sentence
    people[:cast].each do |member|
      people_indexes[member[:name]] = []
      if sentence.include?(member[:name])
        people_indexes[member[:name]] << Utils.get_indexes(sentence, member[:name])
        mentioned_people.push(member[:name])
      end

      member[:characters].each do |character|
        if sentence.include?(character)
          people_indexes[member] << Utils.get_indexes(sentence, character)
          mentioned_people.push(member[:name])
        end
      end
    end

    if people[:directors]
      people[:directors].each do |director|
        people_indexes[director['name']] = []
        if sentence.include?(director['name'])
          people_indexes[director] << Utils.get_indexes(sentence, director['name'])
          mentioned_people.push(director['name'])
        end
      end
    end

    # Check for mentions using pronouns.
    if mentioned_people.empty? && prev_name != nil
      pronouns = ['he', 'him', 'his', 'she', 'her']
        sentence.downcase.gsub(/\W/, ' ').split(/\s+/).each do |word|
          if pronouns.include?(word)
            mentioned_people.push(prev_name)
            break
          end
        end
    end

    return mentioned_people.uniq, mentioned_people.last, people_indexes
  end
end
