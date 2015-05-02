#Annotation Guidlines

*v0.2*

Notes on review annotation process for the *rescore* corpus.

##Introduction
The purpose of the process is to annotate reviews in such a way that it is made clear what the desired and expected output of the algorithm needs to be. Annotations are the ideal, at least up to a point. Some features of language are too complex to detect and are deliberately discounted and marked.

It is important that sentences are tagged with all their mentioned aspect and in turn each aspect with its correct sentiment polarity, positive or negative. There are 11 aspects, and allowed sentiment scores are from -2, -1, 0, 1 &+2. It's inevitable that those annotating the reviews will not always agree on the sentiment score as long as each mentioned aspect is tagged with a correct sentiment polarity the annotation as a whole is said to be correct.

##Examples
These are three examples of output from a correctly annotated review. They show the annotation syntax and cover the two most common mistakes made by annotators.

1. *The acting was good, and had a really good story.*

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
      "justification": "good"
    },
```
**Note**: justification doesn't include `really` or the keyword `story`. Just the minimum required to represent the **sentiment polarity**. Features like exaggeration are accounted for in the score (note 2 rather than one in the second example).

2. *John Doe is great in the amazing 'The Film Title'*

```
  "aspects": {
    "cast": {
      "words": [
         "cast-member-mention"
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
**Note**: negation is accounted for both in the score and in the sentence comment.


##Review Selection
Reviews should be selected for variation in:

* Film Genre
* Length / Depth
* Assigned Score (★ ratings etc)
* 'Helpfulness' Scores

##Format

There is a script: `corpus/annotation_assistant.rb` for walking through the annotation process. It will save a `.json` file automatically at the end. It starts by taking some review metadata & review content and then proceeds to walk through each sentence in turn building the annotations in the terminal.

##Peer Annotation Revision

1. Peer Annotation Revision (PAR) is the second phase of the procedure. It is a post-annotation process carried out in order to ensure that our NLP team is consistent in the assignment of sentiment values and detection of keywords that the rescore should detect. 
2. It ensures that all team NLP annotators arrive at the agreement over the linguistic  and technical discrepancies which arise during the process of review annotation which is typically done by team members.
3. Unlike Review Annotation, PAR is not an automatated process. All marked annotations are thoroughly examined to make sure that the material provided for benchmarking the algorithm is consistent.
4. During PAR, each annotation is revisited by at least one member of the NLP team, other than the original annotator. Line by line, the reviewer compares the annotation markup and makes edits and suggestions as they see fit. These are then pushed as a commit and reviewed on GitHub.
5. Once the discrepancies have been highlighted and a compromise achieved the changes are made to annotated reviews.
6. Doing this for a large number of reviews generates a consistent corpus ready for use in benchmarking our algoritm.

##Refinement & Benchmarking

Refinement is the process of modifying the algorithm parameters (keywords for aspects and the dictionary of sentiment values) to minimise the differences between the annotated corpus and algorithm output.

Refinement is a partially automated process using `benchmark.rake`. This tool performs the comparison described in above. The NLP team individually tune the parameters to minimise the discrepancy score: `correct - wrong / annotations_count`. 

These changes are important to review on a corpus level since it's often the case that changes aren't universally correct. Changes made are then pushed and reviewed by another member of the team on GitHub (potentially many times) before the edits are accepted.

The achieved percentage is not expected to be 100%, there many annotations that cover cases we do not currently account for. This is acceptable and provides examples of areas for future improvement.



