class ChangeVotesPositiveColumnTypeToInteger < ActiveRecord::Migration[5.0]
  def self.up
    change_table :votes do |t|
      t.remove :positive
      t.integer :value, null: false, default: 1
    end
  end

  def self.down
    change_table :votes do |t|
      t.remove :value
      t.boolean :positive, default: true, null: false
    end
  end
end
