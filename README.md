# TopicDemo

A discussion system that automatically tries to detect off-topic comment threads, and split them off into new discussions.

## The gist

It's a basic Article -> Discussion -> Comment system. Each article begins with a single default discussion, which comments can be posted to. They can also be voted positive or negative, and if a string of comments get enough negative votes, then the entire tree of comments will be moved to a new discussion.

Requests to the server are made via Ajax, while updates are received through a web socket (using [Faye Websockets](https://github.com/faye/faye-websocket-ruby)).

## Implementation

Methods of note:

`Discussion#find_children_of(comment)` retrieves all comments of discussion and returns only those descended from `comment`.

`Comment#exceeds_negative_threshold?` finds the average rating of itself and all its descendant comments, and returns whether or not it's worse than a predetermined value. Always returns false if there are fewer than 5 child comments.

`Comment#find_source_of_negativity` traverses up the comment tree to return the highest comment in an unbroken string of negatively rated comments. (This could just return self.)

`Comment#form_new_discussion(options)` forms a new discussion. The discussion is marked as having been branched off of the comment's original discussion, and the comment and all its descendants are moved into it. If `options` contains `:hide => true`, then the new discussion will be greyed out wherever it's linked.

Each time a comment is updated to change its rating, if its rating is below 0 the controller starts to check of the presence of a negative thread. First, it calls `find_source_of_negativity` to find the root of the possible thread. Then given that root, it calls `exceeds_negative_threshold?` to see if the subthread is bad enough to branch off. If so, the root receives `form_new_discussion(hide: true)` which moves it and its descendents away from the current discussion.

## Testing

There's a button on the root page called `Generate demo article`. It will seed a new article with a bunch of off-topic comments. A single down-vote on any of the negative rated comments will be enough to trip the detection method and push them into a parallel discussion.

## Things that could be nice to do

There's a lot of db crawling to check the rating of child and parent comments. A little Redis or Memcached here and there would be the next thing to add, if the system is to scale.

The Discussion model has methods for banishing or promoting comments and their descendants (promotion being the same as "banish" but without graying out its link), so an admin option to manually choose which threads to branch off would be useful.
