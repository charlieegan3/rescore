require 'treat'
require 'ots'
require 'pry'
require 'colorize'

include Treat::Core::DSL
# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

sound = ['sound', 'music', 'surround', 'dolby', 'ears', 'audio', 'effects', 'sounds', 'score']
vision = ['visuals', 'vision', 'screen', 'CGI', '3D','graphics', 'visual', 'eyes', 'spectacle', 'special', 'effects', 'beautiful', 'graphic']
editing = ['editing', 'post', 'production', 'effects']
plot = ['story', 'plot', 'tale', 'narrative', 'characters', 'character', 'journey', 'narration', 'persona']
dialog = ['dialog', 'lines', 'speech', 'discussion', 'conversation', 'language', 'spoken', 'delivery', 'discussion']
cast = ['acting', 'cast', 'performance', 'portrayal', 'depiction', 'characterization', 'impersonation', 'role', 'persona']

print 'Reading From:'.colorize(:white).on_black.underline
puts directory = '../reviews/movie'

Dir.foreach(directory) do |item|
  next if item == '.' or item == '..'
  content = File.readlines("#{directory}/#{item}").last
  next if content.count('.') < 10
  print 'Review:'.colorize(:white).on_black.underline
  puts content
  puts
  paragraph(content).segment.to_a.each do |sentence|
    keywords = OTS.parse(sentence).keywords

    sound_union = sound & keywords
    unless sound_union.empty?
      print 'Sentence: '.colorize(:black).bold
      puts sentence
      print " - sound words => ".colorize(:blue)
      puts "{#{sound_union.join(", ")}}"
    end
    vision_union = vision & keywords
    unless vision_union.empty?
      print 'Sentence: '.colorize(:black).bold
      puts sentence
      print " - vision words => ".colorize(:red)
      puts "{#{vision_union.join(", ")}}"
    end
    editing_union = editing & keywords
    unless editing_union.empty?
      print 'Sentence: '.colorize(:black).bold
      puts sentence
      print " - editing words => ".colorize(:green)
      puts "{#{editing_union.join(", ")}}"
    end
    plot_union = plot & keywords
    unless plot_union.empty?
      print 'Sentence: '.colorize(:black).bold
      puts sentence
      print " - plot words => ".colorize(:light_magenta)
      puts "{#{plot_union.join(", ")}}"
    end
    dialog_union = dialog & keywords
    unless dialog_union.empty?
      print 'Sentence: '.colorize(:black).bold
      puts sentence
      print " - dialog words => ".colorize(:light_blue)
      puts "{#{dialog_union.join(", ")}}"
    end
    cast_union = cast & keywords
    unless cast_union.empty?
      print 'Sentence: '.colorize(:black).bold
      puts sentence
      print " - cast words => ".colorize(:yellow)
      puts "{#{cast_union.join(", ")}}"
    end
  end
  gets
  system("clear")
end

