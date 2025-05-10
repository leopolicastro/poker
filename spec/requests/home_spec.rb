require "rails_helper"

RSpec.describe "Homes", type: :request do
  describe "GET /show" do
    before do
      create(:game, :with_simulated_players, players_count: 3)
    end

    it "returns http success" do
      get "/"
      expect(response.body).to include("Poker")
    end
  end
end
