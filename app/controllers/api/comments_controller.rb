class Api::CommentsController < ApplicationController

  def index
    comments = Comment.where(discussion_id: params[:discussion_id])
    render json: comments
  end

  def create
    discussion = Discussion.find(params[:discussion_id])
    comment = discussion.comments.build(new_comment_params)
    comment.save

    # This is where we want to find all the websockets for this discussion
    # and send them some javascript
    websockets = clients(controller: :discussions, id: params[:discussion_id].to_i)
    # p "NUMBER OF CLIENTS TO UPDATE: #{websockets.size}"
    json = {
      functionName: "appendNewComment",
      params: comment.as_json
      }.to_json
    websockets.each { |ws| ws.send(json) }

    # render json: comment, status: :created
    render json: nil, status: :created
  end

  # Used only for voting
  def update
    comment = Comment.find(params[:id])

    # ratings will be 1 or -1. non numbers will conveniently translate to 0
    comment.rating += params[:rating].to_i
    comment.save

    websockets = clients(controller: :discussions, id: comment.discussion_id)
    # p "NUMBER OF CLIENTS TO UPDATE: #{websockets.size}"
    json = {
      functionName: "updateRating",
      params: {
        id: params[:id],
        rating: comment.rating
        }
      }.to_json
    websockets.each { |ws| ws.send(json) }

    if comment.rating < 0
      # Step 1: look upward for the earliest negative comment (might be self)
      root_comment = comment.find_source_of_negativity
      p "PRUNING: #{root_comment.summary_snippet} is the font of madness"

      # Step 2: check all its children for overal negativity
      if root_comment.discussion.visible && root_comment.exceeds_negative_threshold?

        old_discussion_id = comment.discussion_id

        new_discussion = root_comment.form_new_discussion(hide: true)

        # Notify subscribers of article that a new discussion has formed
        article_clients = clients(controller: :articles, id: comment.discussion.article_id)
        puts "NUMBER OF ARTICLE CLIENTS TO UPDATE: #{article_clients.size}"
        article_json = {
          functionName: "addDiscussion",
          params: new_discussion.as_json
        }.to_json
        article_clients.each { |ws| ws.send(article_json) }

        # Notify subscribers of old discussion to remove the offending comments
        discussion_clients = clients(controller: :discussions, id: old_discussion_id)
        puts "NUMBER OF DISCUSSION CLIENTS TO UPDATE: #{discussion_clients.size}"
        discussion_json = {
          functionName: "newDiscussionFromComments",
          params: new_discussion.as_json.merge(ids: new_discussion.comment_ids)
          }.to_json
        discussion_clients.each { |ws| ws.send(discussion_json) }
      end
    end

    render json: nil, status: :ok
  end

  private
  def new_comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

end
