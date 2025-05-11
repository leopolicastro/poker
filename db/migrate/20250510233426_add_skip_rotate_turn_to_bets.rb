class AddSkipRotateTurnToBets < ActiveRecord::Migration[8.0]
  def change
    add_column :bets, :rotate_turn, :boolean, default: true, null: false
  end
end
