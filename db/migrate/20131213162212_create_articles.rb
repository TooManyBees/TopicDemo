class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :text
      t.timestamps
    end
  end
end
