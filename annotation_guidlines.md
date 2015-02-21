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

1. Emphasis and Exaggeration
2. People & Cast
3. Negation & Double Negation
4. Sentiment & Negation that span multiple sentences

We should differ reviews with more complex language to a later iteration.

##Annotations

###Aspect Words

Current aspect list. Currently, as with sentiment, only individual words and not phrases are used.

We should also assign 'untargetted' comments at the **movie as a whole.**

```
editing:
  'editing' ->               100,
  'effects' ->               70
  'post production' ->       50,
  
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
  'dialogue' ->              100,
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

To reduce ambiguity we're taking sentiment values from: [sentimental](https://github.com/7compass/sentimental/blob/master/lib/sentiwords.txt). The plan is to update & refine this as we move on.

Running `ruby corpus/lookup.rb {WORD}` from the root of the project runs a simple script to get a score for the word.

##Format
Choose reviews based on the criteria in review selection.

Use `ruby corpus/annotation_assistant.rb` to guide you through the process. It will save a `.json` file at the end.
