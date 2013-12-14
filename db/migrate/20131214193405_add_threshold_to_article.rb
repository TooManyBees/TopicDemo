class AddThresholdToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :comment_threshold, :integer, default: 10
  end
end
