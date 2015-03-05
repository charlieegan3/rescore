#Annotation Guidlines

*v0.2*

Notes on review annotation for the *rescore* corpus.

##Basics
The key is to get spot all the mentioned aspects and tag them correctly with positive or negative sentiment. Scoring -1 vs -2 isn't a big deal, but missing an aspect or assigning positive to a megative mention is a problem.

##Examples
Some examples based on common mistakes.

1. *The acting was good, and had a really great story.*

```
  "aspects": {
    "cast": {
      "words": [
         "acting"
      ],
      "score": "1",
      "justification": "good"
    },
    "plot": {
      "words": [
         "story"
      ],
      "score": "2",
      "justification": "great"
    },
```
**Note**: justification doesn't include `really`. Just the minimum required to represent the sentiment.

2. *John Doe is great in the amazing 'The Film Title'*

```
  "aspects": {
    "cast": {
      "words": [
         "cast-member mention"
      ],
      "score": "2",
      "justification": "great"
    },
    "movie": {
      "words": [
         "film-title mention"
      ],
      "score": "2",
      "justification": "amazing"
    },
```
**Note**: keep annotations generic, aim to make justifications and keywords applicable to multiple reviews.

3. *This movie isn't bad*

```
  "aspects": {
    "movie": {
      "words": [
         "movie"
      ],
      "score": "1",
      "justification": "isn't bad"
    }
  }
  "comments" : "negation present"
...
```
**Note**: negation is accounted for and commented at the end.


##Review Selection
Reviews should be selected for variation in:

* Film Genre
* Length / Depth
* Assigned Score (★ ratings etc)
* 'Helpfulness' Scores
* Source (IMDb, Rotten Tomatoes...)

##Language Features
* Comment if a sentence contains negation
* Ignore emphasis in justifications, it can still influence the score.

##Format
Choose reviews based on the criteria in review selection.

Use `ruby corpus/annotation_assistant.rb` to guide you through the process. It will save a `.json` file at the end.
