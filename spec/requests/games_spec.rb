require "rails_helper"

RSpec.describe "Games", type: :request do
  include_context "authenticated user"

  let(:game) { create(:game, :with_simulated_players, players_count: 2) }

  describe "GET /show" do
    it "returns http success" do
      get "/games/#{game.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
