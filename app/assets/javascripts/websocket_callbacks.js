(function(root) {

  var discussion = root.discussion = (root.discussion || {});

  // Should take params = {parentId: "parent_comment_id", data: "comment_json"}
  discussion.appendNewComment = function(params) {
    var newHtml = root.commentTemplate(params);
    $('.comment-list').append(newHtml);
  }

  // Should take params = {id: "comment_id", rating: "comment_rating"}
  discussion.updateRating = function(params) {
    $('.comment-rating[data-id='+params.id+']').html(params.rating);
  }

  discussion.newDiscussionFromComments = function(params) {
    discussion.addDiscussion(params);
    // do more to remove items
    var $commentList = $(".comment-list");
    $.each(params.ids, function(i,id) {
      $commentList.children("li[data-id="+id+"]").remove();
    })
  }

  discussion.addDiscussion = function(params) {
    console.log("adding a discussion to the list!")
    var html = root.discussionListTemplate(params);
    console.log(html);
    $('#discussion-list').append(html);
  }

})(this);
