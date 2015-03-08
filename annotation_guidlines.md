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

#Peer Annotation Revision Guildelines

1. The Peer Annotation Revision is the second phase of the Golden Standard procedure. It is a post-annotation process carried out in order to ensure that our NLP team is consistent in the evaluation of sentiment values as well as detection of keywords that the rescore algorithm is supposed detect. 
2. It ensures that all team NLP annotators arrive at the agreement over the linguistic  and technical discrepancies which arise during the process of Review annotation which is typically done by different people.
3. Unlike Review Annotation, PAR is a manual process. It involves that all review annotations are thoroughly examined to make sure that the material provided for the algorithm is of the same quality.
4. During PAR, each review annotation is revisited by at least one member of the NLP team, other than the original annotator. Line after line, the reviewer compares the resulting JSON file with their own judgment and proposes changes which are then listed in the GitHub commit and can be discussed on the forum.
5. Once the discrepancies have been confronted and a compromise achieved the changes are made to JSON files which are now the basis for the next phase of the Golden Standard procedure.

#Rescore Refinement
1. Rescore Refinement is a process of modifying the parameters of the algorithm (keywords for aspects and the dictionary of sentiment values) to minimise the differences between the distribution of the human-detected aspects in the reviews (which are stored in JSON files) and how the algorithm actaully works.
2. Rescore Refinement is an automated process based on benchmark make, which exactly the type of comparison that was described in 1. The NLP team individually revise the list of the rescore-human annotation discrepancies and try to minimise their amount which is reflected by the ....... percentage rate (whatever the name is).
3. The assumption of the Rescore Refinement is the benchmark of ..... % for the ...... percentage rate that should be achieved for every reviews (or average for all?). Ensuring the RR has improved the percentage guarantees that the declared Golden Standard has been achieved for their algorithm.
4. The declared percentage also ensures that certain discrepancies based on more complicated linguistic concepts that rescore is not yet ready to parse, are accepted with our Golden Standard. The future development of the algorithm will allow to minimise the amount of such inparsable structures.
