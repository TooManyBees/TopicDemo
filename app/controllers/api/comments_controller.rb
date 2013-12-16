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
    websockets = clients(controller: :discussions, id: params[:discussion_id])
    p "NUMBER OF CLIENTS TO UPDATE: #{websockets.size}"
    websockets.each do |ws|
      json = {
        functionName: "appendNewComment",
        params: {
          data: comment.as_json
          }
        }.to_json
      ws.send(json)
    end

    # render json: comment, status: :created
    render json: nil, status: :created
  end

  # Used only for voting
  def update
    comment = Comment.find(params[:id])

    # ratings will be 1 or -1. non numbers will conveniently translate to 0
    comment.rating += params[:rating].to_i
    comment.save

    websockets = clients(controller: :discussions, id: comment.discussion_id.to_s)
    p "NUMBER OF CLIENTS TO UPDATE: #{websockets.size}"
    websockets.each do |ws|
      json = {
        functionName: "updateRating",
        params: {
          id: params[:id],
          rating: comment.rating
          }
        }.to_json
      ws.send(json)
    end

    if comment.rating < 0
      # Step 1: look upward for the earliest negative comment (might be self)
      root_comment = comment.find_source_of_negativity
      p "PRUNING: #{root_comment.summary_snippet} is the font of madness"

      # Step 2: check all its children for overal negativity
      if root_comment.discussion.visible && root_comment.exceeds_negative_threshold?
        root_comment.form_new_discussion(hide: true)

        # This is where we want to find all the websockets for this discussion
        # and send them some javascript to remove all these comments
      end
    end

    render json: nil, status: :ok
  end

  private
  def new_comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

end
