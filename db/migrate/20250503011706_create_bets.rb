class CreateBets < ActiveRecord::Migration[8.0]
  def change
    create_table :bets do |t|
      t.references :player, null: false, foreign_key: true
      t.integer :amount, default: 0, null: false
      t.integer :state, default: 0, null: false
      t.boolean :answered, default: false, null: false

      t.timestamps
    end
  end
end
