class AddOddsToRound < ActiveRecord::Migration[8.0]
  def change
    add_column :rounds, :odds, :json, default: {}, null: false
  end
end
