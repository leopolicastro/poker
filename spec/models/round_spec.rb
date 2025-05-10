require "rails_helper"

RSpec.describe Round, type: :model do
  it "has a valid factory" do
    expect(build(:round)).to be_valid
  end

  describe "associations" do
    it { is_expected.to belong_to(:hand) }
    it { is_expected.to have_many(:bets).dependent(:destroy) }
  end

  describe "delegations" do
    it { is_expected.to delegate_method(:deck).to(:game) }
    it { is_expected.to delegate_method(:players).to(:game) }
    it { is_expected.to delegate_method(:current_turn).to(:game) }
  end

  describe "scopes" do
    let(:game) { create(:game, :with_simulated_players, players_count: 2) }
    let(:pre_flop) { game.current_round }
    let(:flop) { create(:round, type: "Rounds::Flop", hand: pre_flop.hand) }
    let(:turn) { create(:round, type: "Rounds::Turn", hand: flop.hand) }
    let(:river) { create(:round, type: "Rounds::River", hand: turn.hand) }
    let(:showdown) { create(:round, type: "Rounds::Showdown", hand: river.hand) }

    describe ".pre_flop" do
      it "returns the pre flop rounds" do
        expect(Round.pre_flop).to include(pre_flop)
      end
    end

    describe ".flop" do
      it "returns the flop rounds" do
        expect(Round.flop).to include(flop)
      end
    end

    describe ".turn" do
      it "returns the turn rounds" do
        expect(Round.turn).to include(turn)
      end
    end

    describe ".river" do
      it "returns the river rounds" do
        expect(Round.river).to include(river)
      end
    end

    describe ".showdown" do
      it "returns the showdown rounds" do
        expect(Round.showdown).not_to include(pre_flop)
        expect(Round.showdown).to include(showdown)
      end
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
