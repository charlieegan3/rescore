module Negation
  def Negation.tag_negation(sentence)
    negative = "no,not,Nobody,Nothing,Neither,Nowhere,Never,n't,Hardly,scarcely,barely,but,instead"
    sentence.split().each do |word|
      if negative.include?(word)
        puts word
      end
    end
  end
end
