class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :content, null: false
      t.string :commentable_type, null: false
      t.integer :commentable_id, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_index :comments, [:user_id, :commentable_id, :commentable_type], name: 'index_comments_on_user_and_commentable'
  end
end
