class CreateRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.references :current_turn, null: false, foreign_key: {to_table: :players}
      t.integer :phase, null: false, default: 0
      t.timestamps
    end
  end
end
