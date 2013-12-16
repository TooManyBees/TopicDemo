(function(root) {

  var discussion = root.discussion = (root.discussion || {});

  // Should take params = {parentId: "parent_comment_id", data: "comment_json"}
  discussion.appendNewComment = function(params) {
    var newHtml = root.commentTemplate(params.data);
    $('.comment-list').append(newHtml);
  }

  // Should take params = {id: "comment_id", rating: "comment_rating"}
  discussion.updateRating = function(params) {
    $('.comment-rating[data-id='+params.id+']').html(params.rating);
  }

})(this);
