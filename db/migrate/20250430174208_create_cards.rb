class CreateCards < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.references :deck, null: false, foreign_key: true
      t.references :cardable, polymorphic: true, null: true
      t.integer :position
      t.string :rank
      t.string :suit

      t.timestamps
    end
  end
end
