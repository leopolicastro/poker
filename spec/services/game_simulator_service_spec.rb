require "rails_helper"

RSpec.describe GameSimulatorService, type: :service do
  describe "#run" do
    it "creates a game when there are no games" do
      expect(Game.count).to eq(0)
      GameSimulatorService.run
      expect(Game.count).to eq(1)
    end

    it "finds the game when there is one" do
      create(:game, name: "Demo Game")
      expect(Game.count).to eq(1)
      GameSimulatorService.run
      expect(Game.count).to eq(1)
    end

    let(:game) { GameSimulatorService.run(players_count: 2) }
    let(:player) { game.players.big_blind.first }
    let(:player2) { game.players.small_blind.first }

    context "pre flop" do
      it "takes the blinds correctly" do
        expect(player.current_holdings).to eq(980)
        expect(player2.current_holdings).to eq(990)
      end

      it "assigns the first turn to the player to the left of the big blind" do
        expect(player2.turn).to be_truthy
      end
    end
  end
end
