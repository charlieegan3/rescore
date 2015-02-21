require 'sentimental'

Sentimental.load_defaults

word = ARGV[0]
analyzer = Sentimental.new
p analyzer.get_score(word)

