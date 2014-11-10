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
    end
    (emphasis_counts.to_f / words.size).round(2)
  end
end

p Emphasis.score('this is a sentence with no emphasis')
p Emphasis.score('this is a sentence with SOME emphasis')
p Emphasis.score('this is a sentence with SOME MORE emphasis!')
p Emphasis.score('THIS is a sentence <strong>with</strong> **even** MORE emphasis!')
p Emphasis.score('THIS!!! sentence!!! <i>is</i> ALL emphasis!!!')