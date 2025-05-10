require "rails_helper"

RSpec.describe Hands::Straight, type: :model do
  let(:deck) { create(:deck) }

  describe ".satisfied?" do
    context "when the A is high" do
      it "returns true when the cards are in consecutive order" do
        hand = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "2", suit: "Heart"),
          deck.cards.find_by(rank: "3", suit: "Club"),
          deck.cards.find_by(rank: "4", suit: "Spade"),
          deck.cards.find_by(rank: "5", suit: "Diamond"),
          deck.cards.find_by(rank: "6", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Club"),
          deck.cards.find_by(rank: "10", suit: "Spade")
        ], player_id: 1)

        expect(described_class.satisfied?(hand)).to be_truthy
      end

      it "returns false when the cards are not in consecutive order" do
        cards = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "2", suit: "Heart"),
          deck.cards.find_by(rank: "3", suit: "Club"),
          deck.cards.find_by(rank: "4", suit: "Spade"),
          deck.cards.find_by(rank: "5", suit: "Diamond"),
          deck.cards.find_by(rank: "7", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Diamond"),
          deck.cards.find_by(rank: "9", suit: "Diamond")
        ], player_id: 1)

        expect(described_class.satisfied?(cards)).to be_falsey
      end
    end

    context "when the A is low" do
      it "returns true if the cards are in consecutive order" do
        hand = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "2", suit: "Club"),
          deck.cards.find_by(rank: "3", suit: "Spade"),
          deck.cards.find_by(rank: "4", suit: "Diamond"),
          deck.cards.find_by(rank: "5", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Club"),
          deck.cards.find_by(rank: "9", suit: "Club")
        ], player_id: 1)

        expect(described_class.satisfied?(hand)).to be_truthy
      end

      it "returns false if the cards are not in consecutive order" do
        cards = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "2", suit: "Club"),
          deck.cards.find_by(rank: "3", suit: "Spade"),
          deck.cards.find_by(rank: "4", suit: "Diamond"),
          deck.cards.find_by(rank: "6", suit: "Heart"),
          deck.cards.find_by(rank: "7", suit: "Diamond"),
          deck.cards.find_by(rank: "8", suit: "Diamond")
        ], player_id: 1)

        expect(described_class.satisfied?(cards)).to be_falsey
      end
    end
  end

  describe ".top_five" do
    context "when the A is low" do
      it "returns the top five consecutive cards" do
        cards = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "2", suit: "Club"),
          deck.cards.find_by(rank: "3", suit: "Spade"),
          deck.cards.find_by(rank: "4", suit: "Diamond"),
          deck.cards.find_by(rank: "5", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Club"),
          deck.cards.find_by(rank: "9", suit: "Club")
        ].shuffle, player_id: 1)

        expect(described_class.top_five(cards).map(&:to_s)).to eq(["A ♥", "2 ♣", "3 ♠", "4 ♦", "5 ♥"])
      end
    end

    context "when the A is high" do
      it "returns the top five consecutive cards 2,3,4,5,6" do
        hand = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "2", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Club"),
          deck.cards.find_by(rank: "4", suit: "Spade"),
          deck.cards.find_by(rank: "5", suit: "Diamond"),
          deck.cards.find_by(rank: "3", suit: "Club"),
          deck.cards.find_by(rank: "10", suit: "Spade"),
          deck.cards.find_by(rank: "6", suit: "Heart")
        ].shuffle, player_id: 1)

        expect(described_class.top_five(hand).map(&:to_s)).to eq(["2 ♥", "3 ♣", "4 ♠", "5 ♦", "6 ♥"])
      end

      it "returns the top five consecutive cards 10, J, Q, K, A" do
        hand = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Club"),
          deck.cards.find_by(rank: "Q", suit: "Spade"),
          deck.cards.find_by(rank: "J", suit: "Diamond"),
          deck.cards.find_by(rank: "10", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Club"),
          deck.cards.find_by(rank: "8", suit: "Spade")
        ].shuffle, player_id: 1)

        expect(described_class.top_five(hand).map(&:to_s)).to eq(["10 ♥", "J ♦", "Q ♠", "K ♣", "A ♥"])
      end

      it "returns the top five consecutive cards 8,9, 10, J, Q" do
        hand = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Spade"),
          deck.cards.find_by(rank: "5", suit: "Club"),
          deck.cards.find_by(rank: "10", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Diamond"),
          deck.cards.find_by(rank: "9", suit: "Club"),
          deck.cards.find_by(rank: "8", suit: "Spade")
        ].shuffle, player_id: 1)

        expect(described_class.top_five(hand).map(&:to_s)).to eq(["8 ♠", "9 ♣", "10 ♥", "J ♦", "Q ♠"])
      end
    end
  end

  describe "#<=>" do
    context "when comparing hands with different high cards" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "10", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Spade"),
          deck.cards.find_by(rank: "Q", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Heart"),
          deck.cards.find_by(rank: "3", suit: "Spade")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "9", suit: "Heart"),
          deck.cards.find_by(rank: "10", suit: "Spade"),
          deck.cards.find_by(rank: "J", suit: "Club"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Heart"),
          deck.cards.find_by(rank: "3", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher straight" do
        expect(Hands::Straight.new(higher_hand) <=> Hands::Straight.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower straight" do
        expect(Hands::Straight.new(lower_hand) <=> Hands::Straight.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing ace-high vs ace-low straights" do
      let(:ace_high_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "10", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Spade"),
          deck.cards.find_by(rank: "Q", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Heart"),
          deck.cards.find_by(rank: "3", suit: "Spade")
        ], player_id: 1)
      end

      let(:ace_low_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "2", suit: "Spade"),
          deck.cards.find_by(rank: "3", suit: "Club"),
          deck.cards.find_by(rank: "4", suit: "Diamond"),
          deck.cards.find_by(rank: "5", suit: "Diamond"),
          deck.cards.find_by(rank: "6", suit: "Heart"),
          deck.cards.find_by(rank: "7", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 1 when comparing ace-high to ace-low" do
        expect(Hands::Straight.new(ace_high_hand) <=> Hands::Straight.new(ace_low_hand)).to eq(1)
      end

      it "returns -1 when comparing ace-low to ace-high" do
        expect(Hands::Straight.new(ace_low_hand) <=> Hands::Straight.new(ace_high_hand)).to eq(-1)
      end
    end

    context "when comparing middle straights" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "8", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Spade"),
          deck.cards.find_by(rank: "10", suit: "Club"),
          deck.cards.find_by(rank: "J", suit: "Diamond"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Heart"),
          deck.cards.find_by(rank: "3", suit: "Spade")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "7", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Spade"),
          deck.cards.find_by(rank: "9", suit: "Club"),
          deck.cards.find_by(rank: "10", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Heart"),
          deck.cards.find_by(rank: "3", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher straight" do
        expect(Hands::Straight.new(higher_hand) <=> Hands::Straight.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower straight" do
        expect(Hands::Straight.new(lower_hand) <=> Hands::Straight.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing identical hands" do
      let(:hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "10", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Spade"),
          deck.cards.find_by(rank: "Q", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Heart"),
          deck.cards.find_by(rank: "3", suit: "Spade")
        ], player_id: 1)
      end

      it "returns 0 when hands are identical" do
        expect(Hands::Straight.new(hand) <=> Hands::Straight.new(hand)).to eq(0)
      end
    end
  end
end
