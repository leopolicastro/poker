require "rails_helper"

RSpec.describe "Bets", type: :request do
  let(:game) { create(:game) }
  let(:hand) { create(:game_hand, game:) }
  let(:round) { create(:pre_flop, hand:) }

  let(:player) { create(:player, game:, user:) }
  let(:session) { create(:session, user:) }
  let(:user) { create(:user) }

  before do
    allow(Current).to receive(:session).and_return(session)
    allow(Current).to receive(:user).and_return(user)
    round
    player
    create(:player, game:, user: create(:user))
    create(:player, game:, user: create(:user))

    game.assign_starting_positions_and_turn!
  end

  describe "GET /create" do
    it "returns http success" do
      post "/games/#{game.id}/bets", params: {player_id: player.id, amount: game.big_blind}
      expect(response).to redirect_to(root_path)
    end
  end
end
