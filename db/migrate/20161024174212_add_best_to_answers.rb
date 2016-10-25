class AddBestToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :best, :boolean
    add_index :answers, [:question_id, :best], where: 'best = true', unique: true
  end
end
