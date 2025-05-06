require "rails_helper"

RSpec.describe Bet, type: :model do
  it "has a valid factory" do
    expect(build(:bet)).to be_valid
  end

  let(:game) { create(:game) }
  let(:player) { create(:player, game:) }
  let(:player2) { create(:player, game:) }
  let(:hand) { create(:game_hand, game:) }
  let(:round) { hand.rounds.first }
  let(:bet) { create(:bet, player:, amount: 20, round:, bet_type: :check) }
  let(:bet2) { create(:bet, player: player2, amount: 20, round:, bet_type: :check) }

  describe "#payout_winner!" do
    let(:game) { GameSimulatorService.run(players_count: 2) }
    let(:player) { game.players.first }
    let(:player2) { game.players.second }

    before do
      player.place_bet!(amount: player.owes_the_pot, bet_type: :check)
      player2.place_bet!(amount: player2.owes_the_pot, bet_type: :check)
      hand = game.hands.last
    end

    it "gives the chips to the winner" do
      expect(player.current_holdings).to eq(980)
      hand.rounds.create!(type: "Showdown")
      expect(player.current_holdings).to eq(980)
      expect(player2.current_holdings).to eq(1020)
    end

    it "changes the chips to belong to the player" do
      expect(player.reload.chips.first.value).to eq(980)
    end
  end
end

# == Schema Information
#
# Table name: bets
#
#  id         :integer          not null, primary key
#  amount     :integer          default(0), not null
#  answered   :boolean          default(FALSE), not null
#  bet_type   :integer          default("check"), not null
#  state      :integer          default("placed"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :integer          not null
#  round_id   :integer          not null
#
# Indexes
#
#  index_bets_on_player_id  (player_id)
#  index_bets_on_round_id   (round_id)
#
# Foreign Keys
#
#  player_id  (player_id => players.id)
#  round_id   (round_id => rounds.id)
#
