class ArticlesController < ApplicationController

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  # For demo purposes, generates an article with a bunch of negative
  # comments ready for receiving justice
  def seed
    p "Seeding new article"
    a = Article.create(title: "A new article #{Time.now.strftime("%r")}")
    a.seed_with_terribleness
    redirect_to a
  end
end
