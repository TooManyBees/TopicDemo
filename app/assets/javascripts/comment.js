(function(root) {

  var discussion = root.discussion = (root.discussion || {});

  discussion.setup = function() {

    console.log("Discussion js setup");

    var commentFormTemplate = JST['views/new_comment_form'];
    var commentTemplate = JST['views/comment'];

    var discussionId = $('h1').data('id');

    var commentFormHandler = function(event, successCallback) {
      event.preventDefault();
      var data = $(event.target).serializeJSON();

      $.ajax({
        url: "/api/discussions/"+discussionId+"/comments",
        type: "POST",
        dataType: "json",
        data: data,
        success: function(data) {
          // console.log(data);
          $(event.target).children("textarea").val("");
          successCallback(event);
          appendNewComment(data);
        }
      })
    }

    var appendNewComment = function(data) {
      newHtml = commentTemplate(data);
      $('.comment-list').append(newHtml);
    }

    var modifyRating = function($rating, modifier) {
      var currentRating = parseInt($rating.html());
      $rating.html(currentRating + parseInt(modifier));
    }

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
      $li.append(commentFormTemplate({parentId: parentId}));
    })

    // Requests for voting up or voting down
    $('.comment-list').on("click", ".comment-vote-link", function(event) {
      event.preventDefault();
      var commentId = $(event.target).data("id");
      var commentRating = $(event.target).data("rating");
      var $ratingSpan = $(event.target).siblings("span");
      modifyRating($ratingSpan, commentRating);
      console.log(commentId + " -> " + commentRating);

      $.ajax({
        url: "/api/discussions/"+discussionId+"/comments/"+commentId,
        type: "PUT",
        dataType: "json",
        data: {id: commentId, rating: commentRating },
      })
    })

    // One handler for the static comment form at the top, another delegated
    // handler for the ones that get generated
    $('.new-comment-form').on("submit", function(event) {
      commentFormHandler(event, function(e) {});
    });
    $('.comment-list').on("submit", ".new-comment-form", function(event) {
      commentFormHandler(event, function(e) {
        $(e.target).remove();
        $('.comment-reply-link').show();
      });
    });
  }

})(this)
