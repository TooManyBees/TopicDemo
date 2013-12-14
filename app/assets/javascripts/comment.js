$(document).ready(function() {

  var commentFormTemplate = JST['views/new_comment_form'];
  var commentTemplate = JST['views/comment'];

  var discussionId = $('h1').data('id');

  // Requests for posting a comment or replying to comments
  $('.comment-list').on("click", ".comment-reply-link", function(event) {
    event.preventDefault();
    var $li = $(event.target).parent();
    var parentId = $li.data("id");
    // load new comment form template, pass in the parentId as a local
    console.log("Prepping a reply to comment " + parentId);
    $('.comment-list .comment-reply-link').show();
    $(event.target).hide();
    $('.comment-list .new-comment-form').remove();
    $li.append(commentFormTemplate({parentId: parentId, discussionId: discussionId}));
  })

  // Requests for voting up or voting down
  $('.comment-list').on("click", ".comment-vote-link", function(event) {
    event.preventDefault();
    var commentId = $(event.target).data("id");
    var commentScore = $(event.target).data("score");
    console.log(commentId + " -> " + commentScore);
  })

  var commentFormHandler = function(event) {
    event.preventDefault();
    var data = $(event.target).serializeJSON();
    console.log(data);
    // $.ajax({
    //   url: "/discussions/"+discussionId+"/comments",
    //   type: "POST",
    //   dataType: "json",
    //   data: {},
    //   // Success should remove form and unhide link
    //   success: function() {}
    // })
  }

  // One handler for the static comment form at the top, another delegated
  // handler for the ones that get generated
  $('.new-comment-form').on("submit", function(event) {
    commentFormHandler(event);
  });
  $('.comment-list').on("submit", ".new-comment-form", function(event) {
    commentFormHandler(event);
  });
})
