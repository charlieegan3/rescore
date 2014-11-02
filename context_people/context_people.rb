# Given a review, this script finds the cast list for that film.

require 'sentimental'
require 'ots'
require 'treat'
require 'googleajax'
require 'nokogiri'
require 'badfruit'
require 'pry'

GoogleAjax.referrer = "hey"

def get_scope(sentence)
  o = OTS.parse(sentence)
  counts = {}
  film = ""

  o.topics.each do |t|
    counts[t] = 0
    sentence.split("\W").each do |word|
      counts[t] += 1 if word == t
    end
  end

 # puts "Topics: #{o.topics}"
 # puts "Keywords: #{o.keywords}"
 # puts counts

  key = ""
  if sentence.length < 200
    key = sentence
  else
    key = sentence[0..200]
  end

  #puts key
  movie = GoogleAjax::Search.web(key)
  title = movie[:results][0][:title]

  bf = BadFruit.new("6tuqnhbh49jqzngmyy78n8v3")
  movies = bf.movies.search_by_name(title)
  cast = movies[0].full_cast
  reviews = movies[0].reviews

  cast.each do |c|
    puts c.name
  end

end

s1 = "'The Lord of the Rings' is one of my favorite books, I have read it several times, and remember thinking the last time, about 3 years ago that if I made a film I'd want to make it of this, but wouldn't it be almost impossible. You can then imagine how strong my expectations were when I went to see the eagerly awaited first installment.

This film impressed me hugely, more than anything else because of how true it was to my imagination, both in the characters as well as in the effects and setting- a sentiment I have heard consistently from other fans of the books. Elijah Wood brought across the character of Frodo with the kind of haunted, frail courage that Tolkien captures so well in the books. Nor could I find any fault at all with Ian McKellan's Gandalf, Viggo Mortensen's Aragorn, and Sean Bean's Boromir, all of whom I thought were portrayed excellently. I could pick out instances where I did think, 'no, that's not right', however their seldomness in number would only serve to illustrate the excellence of the overall portrayal. One thing that did stand out for me was Cate Blanchett's performance as Galadriel, the part itself became so perfunctory in the film that to me her alternation between benevolent seer, and figure of potential terror seemed little more than a slightly confusing detour with no real connection into the plot other than as a vehicle for a glimpse into the future. But that was it.

I thought that the points where Jackson did deviate from the text were completely the correct ones to do so. Shortening the opening Shire scenes and cutting out the whole Tom Bombadil bit was great since frankly they bored me slightly in the book anyway. Also, expanding the role of Arwen was a sensible decision.

However this film is by no means above criticism. The dialogue was in my opinion terrible and purely there to drive on the plot. Normally this would ruin a film for me (as in 'The Matrix'), making it almost intolerable to view, however fortunately here it proves little more than a minor irritation. Also, the film seemed overall to be excessively plot-driven and at times a mad dash from one action scene to another, the characters, for all their truth to the book did seem flat and sometimes little more than stereotypical fantasy characters. This is perhaps my major quarrel with the film- I would have liked these characters to have come alive as people in a way that was made impossible by the sparseness of the script and the rollercoaster nature of the plot. In general the whole film lacked the depth of context that I think distinguishes Tolkien from other fantasy writers. However to have achieved this would have required a very different movie, and you can't fault an action film for being an action film.

This movie is undoubtedly not for everyone. A lot of people just don't get fantasy- other than Lord of the Rings, I don't particularly either. However in my opinion Jackson really has made an incredible achievement- his and Tolkien's vision carried through suberbly by a breathtaking setting and stunning special effects, as well as by a cast clearly as enthralled as he was. He has taken on a huge task, and is dealing with it with breathtaking success."


s2 = "..but oh was I thankful for it!!! All through the movie I kept on having this big large smile sculpted into my face. For the record, I'm 25 years old, and I've read 'The Lord of the Rings' in three times for the first time when I was six or seven years old. Ever since then, I read it at least once or twice a year - therefore you can count me as a fan, for I follow the same cult fan procedure with 'The Hobbit' and 'The Silmarillion' as well. Now onto the movie... Gosh, I saw it more than one time, and I keep wanting more of it. It just never gets boring! I really enjoyed the little stuff that is found throughout the movie for fans of the books (the map on Bilbo's table in his house comes to mind, it is exactly as the one in 'The Hobbit' book that I own), and I also incredibly enjoyed the intro sequence with the re-telling of the battle against Sauron from the Silmarillion, never has an ultimate evil being been so well depicted on the screen. It truly is Sauron.

Those who argue the movie cuts too many parts or that it changes the story too much are totally wrong. This movie could not have shown the whole first time in its entirety - keep in mind that the audiobook version of 'Fellowship of the Ring' lasts well over ten hours, making a movie this long would, well, make it way too long and besides, how would you financially sustain such a project? I've read a reviewer saying he'd make all three books with the time allowed for the first movie alone. I think it would be a very fast-forwarding experience of a movie with 'Alvin and the Chimpmunks' kind of voices, incredibly stupid to say the least.

Ok, so there are changes in the movie - well, this is Jackson's vision of it. All of us have our own visions of the books, which may or may not be compatible with that of Jackson's, but I can safely assume that nobody can say they have a hundred percent the same vision of the story as Tolkien; that's the thing with books: each reader has a different vision of it. As for me, I was blown away. Never before have I felt so much at home in a movie, it is as if I had taken a walk in the town where I grew up, the Shire, Rivendell, Moria, Lorien, everything felt so much like home, I was moved. I cannot tell of another movie that had me shed tears just by seeing a landscape on screen.

As for the changes, well, I found good reasons behind all of them, and let me tell you right away, I was happy that Arwen saved Frodo, yes, maybe coming from a fan it will look like absolute heresy, but I enjoyed the scene a lot. I did not enjoy it because it was supposedly politically-correct to do so, or that I find Liv Tyler to be absolutely attractive; it was just because I felt like even though it was a big change from the book, it was a very good one indeed, it makes you discover the power, determination, and courage of elves and the fact that even elven women, although great in their beauty and seemingly fragile in appearance do not have anything to envy to their male counterparts. And beside, as Arwen is to become a Queen later on, it was pretty good to see her have a great first appearance.

The actors were great, they were a lot into their characters, and for the first time, I saw elves as they were, quick, agile, terrifyingly effective in battle - just look at how Legolas dealed with the hordes of enemies without a single hint of fear in his eyes - these are elves as they should be. Gimli was great too, I know people seem to think many characters were not developed enough, but by the actions you can learn a lot. With Gimli a lot can be learned about the dwarves, their pride, deep sense of honor and family, their mistrust of elves, their love for strong beer and a good fight against anything bigger, and their sheer hatred for orcs and the likes. Aragorn was totally the ranger character, the ending scene as he walked toward the horde of Uruk-Hai warriors was great, his attitude, his clothes, everything about him just cried 'ranger'. Boromir was very well depicted, desperate to save the people of Gondor, by any mean necessary, robbed of all hope, yet in the end he redeems himself by showing his true valour, deep down, he's willing to die to defeat evil, and when he recognizes his king in Aragorn, on his last breath, I felt like watching a hero die, it was moving. The hobbits were all great, Frodo is deeply sad and fatalist, and Sam is just the 'best friend' everyone would like to have, just as it should be. Finally, we have Gandalf, quite frankly, he looks mighty, Ian IS Gandalf. The faceoff against the Balrog in the Moria is a memorable sequence, and just shows how strong he really is, to be able to vanquish such a foe. I can't wait for his return.

Quite frankly, I can't wait for the two other movies... In the meantime, I'll watch this one over and over again. This movie has everything that a good movie needs to have, and more. Plus, it just might bring more people to actually read books that have more pages than the average little 25¢ novel that has no value in it, which is great. Parents, maybe some scenes will frighten your kids, but this movie has almost NO blood (even though it has a good share of battle) and the foes are undeniably evil, plus it has good values in it - friendship, courage, responsiblity, sacrifice for a good cause, and the belief that anyone can help to change things. This is worthy of Tolkien, this is a movie that will go down in history as being one of the best ever, for sure.

"

get_scope(s2)
