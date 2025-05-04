require "rails_helper"

RSpec.describe Bet, type: :model do
  it "has a valid factory" do
    expect(build(:bet)).to be_valid
  end

  let(:game) { create(:game) }
  let(:player) { create(:player, game:) }
  let(:player2) { create(:player, game:) }
  let(:round) { create(:round, game:, current_turn: player) }
  let(:bet) { create(:bet, player:, amount: 100, round:) }
  let(:bet2) { create(:bet, player: player2, amount: 200, round:) }

  before do
    create(:player_chip, chippable: player, value: 100)
    create(:player_chip, chippable: player, value: 200)
    create(:player_chip, chippable: player, value: 150)
    create(:player_chip, chippable: player2, value: 400)
  end

  describe "#throw_into_pot!" do
    before do
      expect(player.chips.count).to eq(3)
      expect(player.current_holdings).to eq(450)
      bet
    end

    it "consolidates the player's chips into one chip record" do
      # Were here
      expect(player.chips.count).to eq(1)
    end

    it "leaves the player with the correct amount of chips" do
      expect(player.current_holdings).to eq(350)
      expect(player.game.current_holdings).to eq(100)
    end

    it "changes those chips to belong to the game, while the bet is placed" do
      expect(player.game.current_holdings).to eq(100)
      expect(player.current_holdings).to eq(350)
    end
  end

  describe "#payout_winner!" do
    before do
      bet.won!
      bet2.lost!
    end

    it "gives the chips to the winner" do
      expect(player.current_holdings).to eq(550)
      expect(player2.current_holdings).to eq(200)
    end

    it "changes the chips to belong to the player" do
      expect(player.reload.chips.first.value).to eq(100)
      expect(player.chips.last.value).to eq(450)
    end

    it "changes the status of the other bets to lost" do
      expect(player.bets.won.count).to eq(1)
      expect(player2.bets.lost.count).to eq 1
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
