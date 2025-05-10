require "rails_helper"

RSpec.describe Rounds::Flop, type: :model do
  it "has a valid factory" do
    expect(build(:flop)).to be_valid
  end

  let(:game) { create(:game, :with_simulated_players, players_count: 2) }
  let(:hand) { game.current_hand }

  before do
  end

  describe "#handle_round!" do
    before do
      expect(hand.rounds.last.type).to eq("Rounds::PreFlop")
      expect(game.cards.count).to eq(0)
      hand.rounds.last.next_round!
      @flop = hand.rounds.last
    end
    it "adds 3 cards to the board" do
      expect(game.cards.count).to eq(3)
    end

    it "adds 1 card to the burn pile" do
      expect(game.burn_cards.count).to eq(1)
    end

    it "sets turn to false for all players except the first to act" do
      expect(@flop.first_to_act.reload.turn).to be true
      expect(game.players.where.not(id: @flop.first_to_act.id).all? { |p| p.reload.turn == false }).to be true
    end
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  hand_id    :integer          not null
#
# Indexes
#
#  index_rounds_on_hand_id  (hand_id)
#
# Foreign Keys
#
#  hand_id  (hand_id => hands.id)
#
