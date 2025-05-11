require "rails_helper"

RSpec.describe Rounds::PreFlop, type: :model do
  let(:game) { create(:game, :with_simulated_players, players_count: 2) }
  let(:hand) { game.current_hand }
  let(:pre_flop) { game.current_round }
  let(:players) { game.players }

  it "has a valid factory" do
    expect(build(:pre_flop)).to be_valid
  end

  describe "#handle_round!" do
    it "shuffles the deck" do
      expect(pre_flop.deck).to receive(:shuffle!)
      pre_flop.handle_round!
    end

    it "sets game status to in_progress" do
      pre_flop.handle_round!
      expect(game.reload.state).to eq("in_progress")
    end

    it "deals 2 cards to each player" do
      pre_flop.handle_round!
      players.each do |player|
        expect(player.cards.count).to eq(2)
      end
    end

    context "when it's the first hand" do
      it "assigns starting positions" do
        expect(game).to receive(:assign_starting_positions!)
        pre_flop.handle_round!
      end
    end

    context "when it's not the first hand" do
      before do
        allow(game).to receive(:first_hand?).and_return(false)
      end

      it "rotates table positions" do
        expect(RotateTablePositionsService).to receive(:call).with(game: game)
        pre_flop.handle_round!
      end
    end

    it "sets turn to false for all players except the first to act" do
      pre_flop.handle_round!
      expect(pre_flop.first_to_act.reload.turn).to be true
      expect(players.where.not(id: pre_flop.first_to_act.id).all? { |p| p.reload.turn == false }).to be true
    end

    it "sets turn to true for first to act player" do
      pre_flop.handle_round!
      expect(pre_flop.first_to_act.reload.turn).to be true
    end
  end

  describe "#concluded?" do
    let(:active_players) { players.first(3) }
    let(:inactive_player) { players.last }

    before do
      active_players.each { |p| p.send(:active!) }
      inactive_player.send(:folded!)
    end

    context "when all active players have bet at least the big blind" do
      before do
        active_players.each do |player|
          create(:bet, player: player, round: pre_flop, amount: game.big_blind)
        end
      end

      context "when big blind has checked" do
        before do
          allow(pre_flop).to receive(:blind_options_satisfied?).and_return(true)
        end

        it "returns true" do
          expect(pre_flop.concluded?).to be true
        end
      end

      context "when big blind has not checked" do
        before do
          allow(pre_flop).to receive(:blind_options_satisfied?).and_return(false)
        end

        it "returns false" do
          expect(pre_flop.concluded?).to be false
        end
      end
    end

    context "when not all active players have bet at least the big blind" do
      it "returns false" do
        expect(pre_flop.concluded?).to be false
      end
    end
  end

  describe "#blind_options_satisfied?" do
    let(:big_blind_player) { players.first }
    let(:small_blind_player) { players.second }

    before do
      big_blind_player.update!(position: "big_blind")
      small_blind_player.update!(position: "small_blind")
    end

    context "when both blinds have made multiple bets" do
      before do
        create_list(:bet, 2, player: big_blind_player, round: pre_flop)
        create_list(:bet, 2, player: small_blind_player, round: pre_flop)
      end

      it "returns true" do
        expect(pre_flop.blind_options_satisfied?).to be true
      end
    end

    context "when either blind has not made multiple bets" do
      it "returns false" do
        expect(pre_flop.blind_options_satisfied?).to be false
      end
    end
  end

  describe "#first_to_act" do
    let(:big_blind_player) { players.first }

    before do
      big_blind_player.update!(position: "big_blind")
    end

    it "returns the player to the right of the big blind" do
      expect(pre_flop.first_to_act).to eq(big_blind_player.to_the_right)
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
