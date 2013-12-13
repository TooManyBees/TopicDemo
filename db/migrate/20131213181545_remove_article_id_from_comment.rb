class RemoveArticleIdFromComment < ActiveRecord::Migration
  def change
    remove_column :comments, :article_id, :integer, null: false
  end
end
