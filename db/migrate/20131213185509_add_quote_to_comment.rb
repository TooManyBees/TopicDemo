class AddQuoteToComment < ActiveRecord::Migration
  def change
    add_column :comments, :quote, :text
  end
end
