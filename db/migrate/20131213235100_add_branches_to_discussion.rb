class AddBranchesToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :branched_from_discussion_id, :integer
    add_column :discussions, :visible, :boolean, default: true
    remove_column :comments, :visible, :boolean, default: true
  end
end
