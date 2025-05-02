class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.boolean :dealer, null: false, default: false
      t.integer :position, null: false, default: 0
      t.string :table_position, null: false, default: "field"
      t.boolean :turn, null: false, default: false

      t.timestamps
    end
  end
end
