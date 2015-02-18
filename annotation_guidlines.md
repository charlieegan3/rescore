#Annotation Guidlines (proposed)

*v0.1*

Notes on review annotation for the *rescore* corpus.

##Review Selection
Reviews should be selected for variation in:

* Film Genre
* Length / Depth
* Assigned Score (★ ratings etc)
* 'Helpfulness' Scores
* Source (IMDb, Rotten Tomatoes...)

For version one of the corpus reviews and annotations should not cover:

* Negation
* Sentiment that spans sentences
* ...(Suggestions?)

We should differ reviews with more complex language to a later iteration.

##Annotations

###Aspect Words

Current aspect list. Currently, as with sentiment, only individual words and not phrases are used.

We should also assign 'untargetted' comments at the **movie as a whole.**

```
editing:
  'editing' ->               100,
  'effects' ->               70
  'production' ->            50,
  'post' ->                  20,
  
sound:
  'sound' ->                 100,
  'music' ->                 100,
  'dolby' ->                 100,
  'audio' ->                 100,
  'sounds' ->                100,
  'surround' ->              80,
  'ears' ->                  20,
  'score' ->                 10
  
plot:
  'story' ->                 100,
  'plot' ->                  100,
  'narrative' ->             80,
  'narration' ->             80,
  'tale' ->                  30,
  'characters' ->            50,
  'character' ->             50,
  'journey' ->               30,
  'persona' ->               20
  'predictable' ->           80,
  
dialog:
  'dialog' ->                100,
  'speech' ->                100,
  'spoken' ->                90,
  'discussion' ->            80,
  'conversation' ->          80,
  'lines' ->                 70,
  'language' ->              70,
  'delivery' ->              50
  
cast:
  'acting' ->                100,
  'cast' ->                  100,
  'performance' ->           90,
  'portrayal' ->             90,
  'depiction' ->             90,
  'characterization' ->      90,
  'impersonation' ->         90,
  'role' ->                  70,
  'persona' ->               50
  
vision:
  'visuals' ->               100,
  'imax' ->                  100,
  'cgi' ->                   100,
  '3d' ->                    100,
  'graphics' ->              100,
  'visual' ->                100,
  'graphic' ->               90,
  'colour' ->                90,
  'color' ->                 90,
  'vision' ->                90,
  'blurry' ->                80,
  'lifelike' ->              80,
  'screen' ->                70,
  'spectacle' ->             60,
  'eyes' ->                  30,
  'beautiful' ->             20,
  'designs' ->               8  
```

Proposed Additions:

```
length:
  'dragged' ->             100,
  'boring' ->              50,
  'long' ->                50,
  'bloated' ->             70	
	...
	
credibility:
  'true to the book' ->    100,
  'believable' ->          100,
  'true' ->                80,
  'truthful' ->            80,
  'truthfully' ->          70,
  'honest' ->              70,
  'implausible' ->         100,
  'far-fetched' ->         100,
  'improbable' ->          100,
  ...
  
```

###Sentiment

We currently use an average of score from the following dictionaries:

* [sad_panda](https://github.com/mattThousand/sad_panda/blob/master/lib/sad_panda/emotions/term_polarities.rb) (this does a little more than a simple lookup)
* [sentiment_lib](https://github.com/nzaillian/sentiment_lib/blob/master/lib/sentiment_lib/data/analysis/basic_dict/words.txt)
* [simple_sentiment](https://github.com/jherr/sentiment/blob/master/lib/simple_sentiment/dictionary.rb)

Is `-2, -1, 0, 1, 2` the best course of action here? Why not choose a dictionary and use the values in there?


##Format
Comments & Justification:

* Annotated reviews need to be 'machine readable' and convertible to XML
* This is the 1st stage - only simple reviews **as described in 'Review Selection'**
* If you need to write a comment consider the suitability of the review

Human:

```
Original Review
	-Film Title
	-Film Genre
	-Source
	-Rating
	-Helpfulness Scores (high/med/low)
	-Body Text

Annotated:
For each sentence:
	-Original Sentence Text
	For each mentioned aspect:
		-Aspect Name
		-Derived from word or phrase
		-Suggested sentiment value
	Annotator Comments
	
```
XML:

```xml
<movie>
  <original>
    <title></title>
    <genre></genre>
    <source></source>
    <rating></rating>
    <helpfullness></helpfullness>
    <body></body>
  </original>

  <annotated>
    <sentence>
      <text></text>
      <aspects>
        <name></name>
        <source></source>
        <sentiment></sentiment>
      </aspects>
      <comments></comments>
    </sentence>
  </annotated>
</movie>
```
Sample Human:

```
Original
  The Hobbit: An Unexpected Journey
  Adventure
  IMDb
  5
  0.9
  {{long drawn-out review by a disappointed fan}}

Annotated:
  This film was a mega disappointment.
    movie
      film
      SCORE
	No comments for this sentence
  ...(Next Sentence)
```

Sample XML:

```xml
<movie>
  <original>
    <title>The Hobbit: An Unexpected Journey</title>
    <genre>Adventure</genre>
    <source>IMDb</source>
    <rating>5</rating>
    <helpfullness>0.9</helpfullness>
    <body>{{long drawn-out review by a disappointed fan}}</body>
  </original>

  <annotated>
    <sentence>
      <text>This film was a mega disappointment.</text>
      <aspects>
        <name>movie</name>
        <source>film</source>
        <sentiment>SCORE</sentiment>
      </aspects>
      <comments>No comments for this sentence</comments>
    </sentence>
    ...
  </annotated>
</movie>
```
