class AddIntexVotesByUser < ActiveRecord::Migration[5.0]
  def change
    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
