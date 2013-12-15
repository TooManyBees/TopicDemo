class DiscussionsController < ApplicationController

  def create
    article = Article.find(params[:article_id])
    discussion = article.discussions.build(discussion_params)
    if discussion.save
      redirect_to discussion
    else
      redirect_to :back
    end
  end

  def show
    @discussion = Discussion.includes(:branches, :comments).find(params[:id])
  end

  private
  def discussion_params
    params.require(:discussion).permit(:summary)
  end
end
