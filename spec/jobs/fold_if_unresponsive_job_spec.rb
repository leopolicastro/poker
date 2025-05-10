require "rails_helper"

RSpec.describe FoldIfUnresponsiveJob, type: :job do
  let(:game) { GameSimulatorService.run(players_count: 2) }
  let(:player) { game.players.first }
  let(:round) { game.current_round }

  describe "#perform" do
    it "folds the player if they are unresponsive" do
      expect(player.folded?).to be_falsey
      described_class.perform_now(
        round_id: round.id,
        player_id: player.id,
        current_bets_count: 2
      )
      expect(player.reload.folded?).to be_truthy
    end
  end
end
