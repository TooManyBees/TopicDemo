# TopicDemo

A discussion system that automatically tries to detect off-topic comment threads, and split them off into new discussions.

## The gist

It's a basic Article -> Discussion -> Comment system. Each article begins with a single default discussion, which comments can be posted to. They can also be voted positive or negative, and if a string of comments get enough negative votes, then the entire tree of comments will be moved to a new discussion.

## Implementation

Methods of note:
`Discussion#find_children_of(comment)` retrieves all comments of discussion and returns only those descended from `comment`.

`Comment#exceeds_negative_threshold?` finds the average rating of itself and all its descendant comments, and returns whether or not it's worse than a predetermined value. Always returns false if there are fewer than 5 child comments.

`Comment#find_source_of_negativity` traverses up the comment tree to return the highest comment in an unbroken string of negatively rated comments. (This could just return self.)

Each time a comment is updated to change its rating, `exceeds_negative_threshold?` is called to determine if it should be pruned off. If that returns true, `find_source_of_negativity` attempts to find the root of the negative subthread. Then, that root receives `form_new_discussion(hide: true)` which generates a new discussion; the option `hide: true` marks it as not visible, so it gets grayed out wherever it's linked.

## Things that could be nice to do

There's a lot of db crawling to check the rating of child and parent comments. A little Redis or Memcached here and there would be the next thing to add, if the system is to scale.

The Discussion model has methods for banishing or promoting comments and their descendants, so an admin option to manually choose which threads to branch off would be useful.
