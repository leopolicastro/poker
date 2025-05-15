require "rails_helper"

RSpec.describe HandOddsService do
  let(:game) { create(:game, :with_simulated_players, players_count: 2) }
  let(:player1) { game.players.first }
  let(:player2) { game.players.second }

  describe "#call" do
    before do
      # Deal some cards to simulate a real game
      game.deck.draw(count: 2, cardable: player1)
      game.deck.draw(count: 2, cardable: player2)
      game.deck.draw(count: 3) # Flop
    end

    it "returns a hash of player IDs to win percentages" do
      odds = described_class.call(game: game)

      expect(odds).to be_a(Hash)
      expect(odds.keys).to match_array([player1.id, player2.id])
      expect(odds.values.sum).to be_within(0.1).of(100.0)
      odds.values.each do |percentage|
        expect(percentage).to be_between(0.0, 100.0)
      end
    end

    it "returns empty hash when only one player is active" do
      player2.folded!
      odds = described_class.call(game: game)
      expect(odds).to be_empty
    end

    it "takes into account community cards" do
      game.current_round.next_round!

      odds = described_class.call(game: game)

      # Player 1 should have better odds with a pair
      expect(odds[player1.id]).to be > odds[player2.id]
    end
  end
end
