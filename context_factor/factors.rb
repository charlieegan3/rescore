require 'treat'
require 'ots'
require 'pry'

include Treat::Core::DSL
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def dup_hash(ary)
  ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select {
    |k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
end

sound = ['sound', 'music', 'surround', 'dolby', 'ears', 'audio', 'effects', 'sounds', 'score']
vision = ['visuals', 'vision', 'screen', 'CGI', '3D','graphics', 'visual', 'eyes', 'spectacle', 'special', 'effects', 'beautiful', 'graphic']
editing = ['editing', 'post', 'production', 'effects']
plot = ['story', 'plot', 'narrative', 'characters', 'character']
dialog = ['dialog', 'lines', 'speech', 'discussion', 'conversation', 'language']
cast = ['acting', 'cast', 'performance', 'portrayal', 'depiction', 'characterization', 'impersonation']

factors = [
  sound,
  vision,
  editing,
  plot,
  dialog,
  cast
]

puts directory = '../reviews/movie'

Dir.foreach(directory) do |item|
  next if item == '.' or item == '..'
  content = File.readlines("#{directory}/#{item}").last
  if content.count('.') > 10
    puts content
    puts "--"
    paragraph(content).segment.to_a.each do |sentence|
      keywords = OTS.parse(sentence).keywords
      factors.each do |factor|
        union = keywords & factor
        unless union.empty?
          puts sentence
          puts union.size
          puts " -> #{factor.join(" ")}"
          puts '-'*20
        end
      end
    end
    gets
    system("clear")
  end
end

