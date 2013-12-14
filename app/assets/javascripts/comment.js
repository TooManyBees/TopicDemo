$(document).ready(function() {

  // Requests for posting a comment or replying to comments

  // Requests for voting up or voting down
  $('.comment-vote-link').on("click", function(event) {
    event.preventDefault();
    var commentId = $(event.target).data("id");
    var commentScore = $(event.target).data("score");
    console.log(commentId + " -> " + commentScore);
  })
})
