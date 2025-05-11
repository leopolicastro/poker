require "rails_helper"

RSpec.describe Game, type: :model do
  let(:game) { create(:game, :with_simulated_players, players_count: 3) }
  let(:all_in_player) { game.players.first }
  let(:other_players) { game.players.last(2) }

  pending describe "#all_in_payout!" do
    before do
      all_in_player.update!(state: :all_in)
      game.chips.create!(value: 1000)
    end

    it "handles all-in players correctly" do
      game.all_in_payout!(winners: [all_in_player])
      expect(all_in_player.current_holdings).to eq(1000)
    end

    it "handles multiple winners with all-in players" do
      game.all_in_payout!(winners: [all_in_player, other_players.first])
      expect(all_in_player.current_holdings).to eq(500)
      expect(other_players.first.current_holdings).to eq(500)
    end
  end
end
