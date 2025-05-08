require "rails_helper"

RSpec.describe "Bets", type: :request do
  let(:session) { create(:session, user:) }
  let(:user) { create(:user) }

  before do
    allow(Current).to receive(:session).and_return(session)
    allow(Current).to receive(:user).and_return(user)
    @game = GameSimulatorService.run
    @player = @game.players.first
  end

  describe "GET /create" do
    it "returns http success" do
      post "/games/#{@game.id}/bets?type=Fold", params: {player_id: @player.id, amount: @game.big_blind}
      expect(response).to redirect_to(root_path)
    end
  end
end
