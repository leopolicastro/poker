class CreateDecks < ActiveRecord::Migration[8.0]
  def change
    create_table :decks do |t|
      t.references :deckable, polymorphic: true, null: true

      t.timestamps
    end
  end
end
