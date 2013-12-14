# TopicDemo

A discussion system that automatically tries to detect off-topic comment threads, and split them off into new discussions.

## The gist

It's a basic Article -> Discussion -> Comment system. Each article begins with a single default discussion, which comments can be posted to. They can also be voted positive or negative, and if a string of comments get enough votes in one direction they will all be split off into their own parallel discussion.

## TODO

There's a lot of db crawling to check the rating of child and parent comments. A little Redis or Memcached here and there would be the next thing to add, if the system is to scale.
