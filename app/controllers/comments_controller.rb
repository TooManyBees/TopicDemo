class CommentsController < ApplicationController

  respond_to :json

  def index
    @comments = Comment.where(discussion_id: params[:discussion_id])
  end

  def create
    discussion = Discussion.find(params[:discussion_id])
    comment = discussion.comments.build(new_comment_params)
    comment.save
    if request.xhr?
      render json: nil, status: :created
    else
      redirect_to discussion
    end
  end

  # Used only for voting
  def update
    comment.score += params[:comment][:score] # will be 1 or -1
    comment.save
    if request.xhr?
      render json: nil, status: :ok
    else
      redirect_to discussion
    end
  end

  # Returns false if the average of child_comments score poorly
  def this_comment_is_valuable?
    children = discussion.find_children_of(self)
    total_value = children.reduce(0) { |score, comment| score += comment.score }
    average_value = total_value / children.size

    # this attribute "negative_threshold" doesn't exist yet
    # average_value < discussion.article.negative_threshold ? false : true
  end

  private
  def new_comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def update_comment_params
  end
end
