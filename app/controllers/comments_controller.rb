class CommentsController < ApplicationController

  def index
    @comments = Comment.where(discussion_id: params[:discussion_id])
  end

  def create

  end

  def update
  end

  def rate
  end

  def destroy
  end

  private
  def new_comment_params
  end

  def update_comment_params
  end

  def rate_comment_params
  end
end
