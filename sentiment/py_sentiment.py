import sys
from textblob import TextBlob

text = sys.argv[1]

blob = TextBlob(text)

print blob.sentences[0].sentiment.polarity, ',', blob.sentences[0].sentiment.subjectivity

