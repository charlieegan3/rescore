# get_cast() finds the cast list for a film, given a review.
# get_context_people() tries to get context for a sentence, based on cast members or directors.

require 'sentimental'
require 'ots'
require 'treat'
require 'googleajax'
require 'nokogiri'
#require 'badfruit'
require 'pry'
require 'sanitize'
require 'colorize'
require 'unidecoder'
require_relative 'BadFruit/lib/badfruit.rb'
include Treat::Core::DSL

GoogleAjax.referrer = "hey"

def get_cast(review)
  o = OTS.parse(review)
  counts = {}
  film = ""

  o.topics.each do |t|
    counts[t] = 0
    review.split("\W").each do |word|
      counts[t] += 1 if word == t
    end
  end

  key = ""
  if review.length < 200
    key = review
  else
    key = review[0..200]
  end

  movie = GoogleAjax::Search.web(key)
  title = Sanitize.fragment(movie[:results][0][:title])

  begin
    bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
    query = bf.movies.search_by_name(title[0..15]) # Try to cut out irrelevant bits of string.

    cast = query[0].full_cast
    director = query[0].director
    #reviews = query[0].reviews

  rescue NoMethodError
    raise "Couldn't find any movies with title: #{title}"
  end

  return {:cast => cast, :director => director}

end

def get_context_people(sentence, cast, director, prev_name, actors_only)
  puts ("#"*15+" Sentence "+"#"*15).colorize(:blue)
  puts sentence
  sentence = sentence.to_ascii # Get rid of accented letters etc.
  names = [] # The cast members detected in this sentence.
  
  cast.each do |c|
    if sentence.include?(c.name)
      names.push(c.name) if !names.include?(c.name)
    end

    c.characters.each do |ch|
      if sentence.include?(ch)
        names.push(c.name) if !names.include?(c.name) && actors_only == true
        names.push(ch) if !names.include?(ch) && actors_only == false
      end
    end
  end

  if sentence.include?(director.name)
    names.push(director.name) if !names.include?(director.name)
  end

  if names.empty?
    pronouns = ["He", "he", "Him", "him", "His", "his", "She", "she", "Her", "her"]
      sentence.split.to_a.each do |word|
        if pronouns.include?(word) && prev_name != nil
          names.push(prev_name + "(FROM PREVIOUS REFERENCE)") if !names.include?(prev_name + "(FROM PREVIOUS REFERENCE)")
        end
      end
  end

  print "Matches: ".colorize(:red)
  names.each do |n|
    print " #{n}".colorize(:yellow)
  end
  prev_name = names.last

  puts

  return prev_name

end

s1 = "
'The Lord of the Rings' is one of my favorite books, I have read it several times, and remember thinking the last time, about 3 years ago that if I made a film I'd want to make it of this, but wouldn't it be almost impossible. You can then imagine how strong my expectations were when I went to see the eagerly awaited first installment.

This film impressed me hugely, more than anything else because of how true it was to my imagination, both in the characters as well as in the effects and setting- a sentiment I have heard consistently from other fans of the books. Elijah Wood brought across the character of Frodo with the kind of haunted, frail courage that Tolkien captures so well in the books. Nor could I find any fault at all with Ian McKellan's Gandalf, Viggo Mortensen's Aragorn, and Sean Bean's Boromir, all of whom I thought were portrayed excellently. I could pick out instances where I did think, 'no, that's not right', however their seldomness in number would only serve to illustrate the excellence of the overall portrayal. One thing that did stand out for me was Cate Blanchett's performance as Galadriel, the part itself became so perfunctory in the film that to me her alternation between benevolent seer, and figure of potential terror seemed little more than a slightly confusing detour with no real connection into the plot other than as a vehicle for a glimpse into the future. But that was it.

I thought that the points where Jackson did deviate from the text were completely the correct ones to do so. Shortening the opening Shire scenes and cutting out the whole Tom Bombadil bit was great since frankly they bored me slightly in the book anyway. Also, expanding the role of Arwen was a sensible decision.

However this film is by no means above criticism. The dialogue was in my opinion terrible and purely there to drive on the plot. Normally this would ruin a film for me (as in 'The Matrix'), making it almost intolerable to view, however fortunately here it proves little more than a minor irritation. Also, the film seemed overall to be excessively plot-driven and at times a mad dash from one action scene to another, the characters, for all their truth to the book did seem flat and sometimes little more than stereotypical fantasy characters. This is perhaps my major quarrel with the film- I would have liked these characters to have come alive as people in a way that was made impossible by the sparseness of the script and the rollercoaster nature of the plot. In general the whole film lacked the depth of context that I think distinguishes Tolkien from other fantasy writers. However to have achieved this would have required a very different movie, and you can't fault an action film for being an action film.

This movie is undoubtedly not for everyone. A lot of people just don't get fantasy- other than Lord of the Rings, I don't particularly either. However in my opinion Jackson really has made an incredible achievement- his and Tolkien's vision carried through suberbly by a breathtaking setting and stunning special effects, as well as by a cast clearly as enthralled as he was. He has taken on a huge task, and is dealing with it with breathtaking success.
"

s2 = "
Star Wars has been dethroned. Although George Lucas' movies are good in their own right (except for the juvenile elements he puts in to sell toys to finance the franchise), his scripts (which borrow heavily from J.R.R.Tolkien, mythology & religion) can't compare with the brilliance of the literary trilogy `The Lord of the Rings'. Granted, Lucas took on a herculean task in writing & directing his story himself, but Tolkien's words, along with Peter Jackson's faithful adaptation & inspired vision, have created something no one man could equal.

Of course, it helps that Jackson insisted on at least a 2 picture deal, & New Line Cinema was brave enough to foot the bill up front for 3 movies. They spent $180 million to film all 3 simultaneously. With the New Zealand exchange rate, that equals $360 million ($90 million ea.), but since they used many of the same sets, and FX development costs were spread throughout, we're seeing $120-$150 million on the screen. This will ensure consistency in plot, casting, tone, etc.

In 3 hours, Jackson has crammed everything essential from the first novel & then some into the film, rewriting some scenes & dialogue with lesser characters for the leads, leaving out only what there wasn't enough time for. Basically, you have two 90 min. movies running back to back. There are no slow spots, just one climax after another. From the opening 10 min. backstory where the Dark Lord Sauron is shown on the battlefield wiping out men & elves 10 at a time with each swing of his mace, I was blown away. The romance between Aragorn, king in exile, and Arwen, daughter of the elf-lord, is played up for the 'Titanic' quotient, but it's well done.

The story, sets, costumes & FX are so rich, you'll have to see the film several times to absorb everything. The unspoiled New Zealand locales are spectacular, providing a variety of environments to represent the different settings on the characters' journey. The location sets are imaginative, detailed & weathered, adding to their believability, while the studio sets match them in meticulousness. The costumes are at once familiar & strange, drawing on both the medievil & the fantastic, but more important, they're also functional & practical. The music by Howard Shore is appropriately sweeping, Celtic & folky in keeping with the novel, although it lacks the memorable themes of John Williams or Jerry Goldsmith, but neither would commit a year or more to a 3 picture project. The FX are as they should be, unobtrusive & unnoticed most of the time, there only to support the story not draw attention away from it as in most Hollywood movies which try to coverup illogical plots & bad acting.

I'm particularly gratified by the casting of Viggo Mortenson as Aragorn which was a last minute stroke of luck when the actor first chosen for the part backed out due to differences with the director. I've always thought Mortenson had an intensity & striking but not pretty-boy looks that could portray a flawed, dangerous hero instead of the villains Hollywood always picked him for.

A stellar cast giving some of their best performances, visuals that deliver beyond what I imagined, a perfect mix of humor, passion & tragedy, and a feeling of grandeur, scope & impending doom. Perhaps as an ensemble piece with so many characters & the inability to concentrate on any one, it can't be measured against some of the classic character study films, but even the casual moviegoer can grasp the ideas & not get lost As far as I'm concerned, it's one of the greatest films of all time.
"

s3 = "
Truly epic in scale! Whilst 'Gravity' falls short against films like '2001: A Space Odyssey', it is a tense and visually stunning thriller from Alfonso Cuarón. Cuarón is one of my all-time favourite directors, and this CGI-heavy project just boasts skill and ingenuity from the director, DOP and VFX artist. The critics stated that you would be gripping to the edge of your seats, this is true in every aspect, the film is full of intense and thriller situations with amazing performances from Sandra Bullock and George Clooney. Just shy from winning Best Picture over '12 Years a Slave', 'Gravity' left the Oscars with 7 Academy Awards to its name, and it deserved each and every one of them. A masterpiece that allows the viewer to become immersed within the scene to often thrilling effect.
"

review = s3
people = get_cast(review)

puts "CAST".colorize(:red)
people[:cast].each do |c|
  puts c.name
end

puts "DIRECTOR".colorize(:red)
puts people[:director].name


result = nil
paragraph(review).segment.to_a.each do |sentence|
  result = get_context_people(sentence, people[:cast], people[:director], result, true)
end

