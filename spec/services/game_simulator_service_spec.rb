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
  end
end
