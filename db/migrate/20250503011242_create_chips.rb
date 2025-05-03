class CreateChips < ActiveRecord::Migration[8.0]
  def change
    create_table :chips do |t|
      t.float :value
      t.references :chippable, polymorphic: true, null: true

      t.timestamps
    end
  end
end
