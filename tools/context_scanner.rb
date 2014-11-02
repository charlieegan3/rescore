# this file will look through all the reviews and find other words used in the vicinity of the search terms

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
vision = ['visuals', 'vision', 'screen', 'CGI', 'graphics', 'visual', 'eyes', 'spectacle', 'special', 'effects', 'seen', 'beautiful', 'graphic']
editing = ['editing', 'post', 'production', 'effects']
plot = ['story', 'plot', 'narrative', 'characters', 'character']
dialog = ['dialog', 'lines', 'speech', 'discussion', 'conversation']
cast = ['acting', 'cast', 'performance', 'portrayal', 'depiction', 'characterization', 'impersonation']

#make choice here
scan_for = sound

collect = []

puts directory = `pwd`.chomp + '/reviews/movie'

Dir.foreach(directory) do |item|
  next if item == '.' or item == '..'
   content = File.readlines("#{directory}/#{item}").last
   paragraph(content).segment.to_a.each do |sentence|
    keywords = OTS.parse(sentence).keywords
    unless (keywords & scan_for).empty?
      collect += keywords
    end
  end
end

p collect.sort
puts dup_hash(collect).sort_by {|_,v| v}

