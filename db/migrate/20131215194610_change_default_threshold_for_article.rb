class ChangeDefaultThresholdForArticle < ActiveRecord::Migration
  def change
    change_column :articles, :comment_threshold, :integer, default: 5
  end
end
