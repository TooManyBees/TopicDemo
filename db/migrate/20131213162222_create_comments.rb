class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :article_id, null: false
      t.integer :parent_id
      t.text :content

      t.integer :rating, default: 0
      t.boolean :visible, default: true
      t.timestamps
    end
    add_index :comments, :article_id
    add_index :comments, :parent_id
  end
end
