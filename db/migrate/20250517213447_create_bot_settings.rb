class CreateBotSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :bot_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :strategy, default: 0, null: false
      t.text :instructions
      t.boolean :active, default: false, null: false

      t.timestamps
    end
  end
end
