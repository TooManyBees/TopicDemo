class DiscussionsController < ApplicationController

  def show
    @discussion = Discussion.includes(:branches, :comments).find(params[:id])
  end

  private
  def discussion_params
    params.require(:discussion).permit(:summary)
  end
end
