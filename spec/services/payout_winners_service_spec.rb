require "rails_helper"

RSpec.describe PayoutWinnersService, type: :service do
  let(:game) { GameSimulatorService.run(players_count: 2) }
  let(:player) { game.players.first }
  let(:player2) { game.players.second }

  describe "#payout_winner!" do
    before do
      allow(game).to receive(:top_hands).and_return([player2])
    end

    it "gives the chips to the winner" do
      expect(player.current_holdings).to eq(980)
      expect(player2.current_holdings).to eq(990)
      PayoutWinnersService.call(game:)
      expect(player.current_holdings).to eq(980)
      expect(player2.current_holdings).to eq(1020)
    end

    it "changes the chips to belong to the player" do
      expect(player.reload.chips.sum(:value)).to eq(980)
    end
  end
end
