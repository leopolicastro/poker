class CreateDecks < ActiveRecord::Migration[8.0]
  def change
    create_table :decks do |t|
      t.references :game, null: true, foreign_key: true

      t.timestamps
    end
  end
end
