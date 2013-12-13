class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.string :summary, null: false
      t.integer :article_id, null: false

      t.timestamps
    end
    add_index :discussions, :article_id
  end
end
