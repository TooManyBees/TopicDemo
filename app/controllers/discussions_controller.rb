class DiscussionsController < ApplicationController

  def show
    @discussion = Discussion.find(params[:id])
    @comments = @discussion.comments
  end
end
