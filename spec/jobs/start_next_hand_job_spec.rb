require "rails_helper"

RSpec.describe StartNextHandJob, type: :job do
  let(:game) { create(:game, :with_simulated_players, players_count: 2) }

  describe "#perform" do
    it "creates a new hand" do
      expect(game.hands.count).to eq(1)
      described_class.perform_now(game_id: game.id)
      expect(game.hands.count).to eq(2)
    end
  end
end
