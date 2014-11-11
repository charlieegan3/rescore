module Emphasis
  def Emphasis.score(sentence)
    words = sentence.split(' ')
    emphasis_counts = 0
    words.each do |word|
      emphasis_counts += word.split('').count('!').to_f / 2
      emphasis_counts += 1 if word.gsub(/\W+/, '').match(/[A-Z]+/)
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
    end
    return (emphasis_counts.to_f / words.size).round(2)
  end
end
