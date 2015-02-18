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
2. Negation & Double Negation
3. Sentiment & Negation that span multiple sentences

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

To reduce ambiguity we're taking sentiment values from: [sentimental](https://github.com/7compass/sentimental). The plan is to update & refine this as we move on.

Running `ruby lookup.rb {WORD}` from the root of the project runs a simple script to get a score for the word.

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
Overall Sentiment: (+ve/-ve/neutral)
For each sentence:
	-Original Sentence Text
	For each mentioned aspect:
		-Aspect Name
		-Derived from word or phrase
		-Suggested sentiment value
	Annotator Comments
	
```

JSON:

```json
{
  "movie": {
    "original": {
      "title": "",
      "genre": "",
      "source": "",
      "rating": "",
      "helpfullness": "",
      "body": ""
    },
    "annotated": {
      "overall" : "(+ve/-ve/neutral)"
      "sentences": [
        {
          "text": "",
          "aspects": [
            {
              "name": "",
              "source": "",
              "sentiment": ""
            },...]
          "comments": ""
         }
      ]
    }
  }
}

```
