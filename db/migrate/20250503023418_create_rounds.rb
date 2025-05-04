class CreateRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.string :type
      t.timestamps
    end
  end
end
