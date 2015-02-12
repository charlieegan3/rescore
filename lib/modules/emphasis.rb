module Emphasis
  def Emphasis.score(sentence)
    words = sentence.split(' ')
    emphasis_counts = 0
    
    words.each do |word|
      
      emphasis_counts += 1 if word.gsub(/\W+/, '').match(/[A-Z][A-Z0-9]+/)
      emphasis_counts += 1 if word.include?('**')
      emphasis_counts += 1 if word.include?('<em>')
      emphasis_counts += 1 if word.include?('<strong>')
      emphasis_counts += 1 if word.include?('<b>')
      emphasis_counts += 1 if word.include?('<i>')
      emphasis_counts += 1 if word.include?('very')
      emphasis_counts += 1 if word.include?('extremely')
      emphasis_counts += 1 if word.include?('highly')
      emphasis_counts += 1 if word.include?('complete')
      emphasis_counts += 1 if word.include?('utter')
      emphasis_counts += 1 if word.include?('really')
      emphasis_counts += 1 if word.include?('much')
      emphasis_counts += 1 if word.include?('more')
      emphasis_counts += 1 if word.include?('truly')
      emphasis_counts += 1 if word.include?('such')
      emphasis_counts += 1 if word.include?('total')
      emphasis_counts += 1 if word.include?('totally')
    end
    exclems = 0
      exclems += sentence.count('?')
      if exclems == 0
        emphasis_counts += 0.0
      elsif exclems == 1
        emphasis_counts += 1.0
      elsif exclems == 2
        emphasis_counts += 2.0
      else 
        emphasis_counts += 3.0
      end
      emphasis_counts += sentence.count('!').to_f / 2
    return (emphasis_counts.to_f / words.size).round(2)
  end
end
