require "rails_helper"

RSpec.describe "Bets::Raises", type: :request do
  let(:game) { create(:game, :with_simulated_players, players_count: 2) }
  let(:player) { game.players.first }

  describe "POST /games/:game_id/bets/raises" do
    it "returns http success" do
      post game_bets_raises_path(game), params: {player_id: player.id, amount: 10}
      expect(response).to have_http_status(:redirect)
    end
  end
end
