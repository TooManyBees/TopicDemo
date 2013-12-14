class CommentsController < ApplicationController

  def index
    @comments = Comment.where(discussion_id: params[:discussion_id])
  end

  def create
    discussion = Discussion.find(params[:discussion_id])
    comment = discussion.comments.build(new_comment_params)
    comment.save
    redirect_to discussion
  end

  private
  def new_comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def update_comment_params
  end

  def rate_comment_params
  end
end
