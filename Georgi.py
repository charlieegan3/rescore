import nltk 
import time
sentence = input()
S1 = set(nltk.word_tokenize(sentence))
negative = "no,not,Nobody,Nothing,Neither,Nowhere,Never,n't,Hardly,scarcely,barely,but,instead" 
S2 = set(nltk.word_tokenize(negative))
s3 = S1.intersection(S2)
print(s3) 
time.sleep(5.5)