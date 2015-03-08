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

##Peer Annotation Revision

1. Peer Annotation Revision (PAR) is the second phase of the procedure. It is a post-annotation process carried out in order to ensure that our NLP team is consistent in the assignment of sentiment values and detection of keywords that the rescore should detect. 
2. It ensures that all team NLP annotators arrive at the agreement over the linguistic  and technical discrepancies which arise during the process of review annotation which is typically done by team members.
3. Unlike Review Annotation, PAR is a manual process. It involves checking all marked annotations are thoroughly examined to make sure that the material provided for the algorithm is consistent.
4. During PAR, each review annotation is revisited by at least one member of the NLP team, other than the original annotator. Line by line, the reviewer compares the annotation markup and makes edits and suggestions as they see fit. These are then pushed as a commit and reviewed on GitHub.
5. Once the discrepancies have been highlighted and a compromise achieved the changes are made to markup files which are now the basis for the next phase of the Golden Standard procedure.

##Refinement & Adjustments

Refinement is the process of modifying the algorithm parameters (keywords for aspects and the dictionary of sentiment values) to minimise the differences between the annotated corpus and algorithm output.

Refinement is a partially automated process using `benchmark.rake`. This tool performs the comparison described in point 1. The NLP team individually tune the parameters to minimise the discrepancy score: `correct - wrong / annotations_count`.

These changes are important to review on a corpus level since it's often the case that changes aren't universally correct. Changes made are then pushed and reviewed by another member of the team on GitHub (potentially many times) before the edits are accepted.

The declared percentage also ensures that certain discrepancies based on more complicated linguistic concepts that rescore is not yet ready to parse, are accepted with our Golden Standard. The future development of the algorithm will allow to minimise the amount of such 'inparsable' structures.
