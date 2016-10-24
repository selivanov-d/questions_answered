class AddBestToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :best, :boolean
    add_index :answers, [:question_id, :best], unique: true
  end
end
