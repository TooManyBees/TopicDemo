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
      render json: comment.as_json(except: [:created_at, :updated_at], methods: :post_time_in_words), status: :created
    else
      redirect_to discussion
    end
  end

  # Used only for voting
  def update
    comment = Comment.find(params[:id])

    # ratings will be 1 or -1. non numbers will conveniently translate to 0
    comment.rating += params[:rating].to_i
    comment.save

    if comment.rating < 0
      # Step 1: look upward for the earliest negative comment (might be self)
      root_comment = comment.find_source_of_negativity
      p "PRUNING: #{root_comment.summary_snippet} is the font of madness"

      # Step 2: check all its children for overal negativity
      if root_comment.discussion.visible && root_comment.exceeds_negative_threshold?
        root_comment.form_new_discussion(hide: true)
      end
    end

    if request.xhr?
      render json: nil, status: :ok
    else
      redirect_to discussion
    end
  end

  private
  def new_comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
