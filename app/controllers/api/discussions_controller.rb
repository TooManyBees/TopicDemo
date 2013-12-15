class Api::DiscussionsController < ApplicationController

  def create
    article = Article.find(params[:article_id])
    discussion = article.discussions.build(discussion_params)
    if discussion.save
      render json: nil, status: :created
    else
      head :unproccessible_entity
    end
  end

  def show
    discussion = Discussion.find(params[:id])
    render json: discussion
  end

end
