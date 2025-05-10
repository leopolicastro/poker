require "rails_helper"

RSpec.describe Hands::ThreeOfAKind, type: :model do
  let(:deck) { create(:deck) }

  describe ".satisfied" do
    it "returns true when there are three cards with the same rank" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "2", suit: "Club"),
        deck.cards.find_by(rank: "2", suit: "Spade"),
        deck.cards.find_by(rank: "3", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Diamond"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ], player_id: 1)
      expect(described_class.satisfied?(cards)).to be_truthy
    end

    it "returns false when there are no three cards with the same rank" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "3", suit: "Club"),
        deck.cards.find_by(rank: "4", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Diamond"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ], player_id: 1)

      expect(described_class.satisfied?(cards)).to be_falsey
    end
  end

  describe ".top_five" do
    let(:deck) { create(:deck) }
    let(:cards) { (top_five + extras).shuffle }

    let(:extras) {
      [
        deck.cards.find_by(rank: "2", suit: "Spade"),
        deck.cards.find_by(rank: "3", suit: "Club")
      ]
    }

    let(:top_five) {
      [
        deck.cards.find_by(rank: "9", suit: "Spade"),
        deck.cards.find_by(rank: "9", suit: "Heart"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "10", suit: "Diamond"),
        deck.cards.find_by(rank: "4", suit: "Spade")

      ]
    }
    let(:hand) { Hands::Hand.new(cards:, player_id: 1) }

    describe "#top_five" do
      it "returns the top five cards" do
        expect(Hands::ThreeOfAKind.top_five(hand).map(&:to_s)).to eq(["9 ♣", "9 ♥", "9 ♠", "10 ♦", "4 ♠"])
      end
    end
  end

  describe "#<=>" do
    let(:deck) { create(:deck) }

    context "when comparing hands with different three of a kind values" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "Q", suit: "Diamond")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Spade"),
          deck.cards.find_by(rank: "K", suit: "Club"),
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "Q", suit: "Diamond")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher three of a kind" do
        expect(Hands::ThreeOfAKind.new(higher_hand) <=> Hands::ThreeOfAKind.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower three of a kind" do
        expect(Hands::ThreeOfAKind.new(lower_hand) <=> Hands::ThreeOfAKind.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same three of a kind but different first kicker" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "Q", suit: "Diamond")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Diamond")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher first kicker" do
        expect(Hands::ThreeOfAKind.new(higher_hand) <=> Hands::ThreeOfAKind.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower first kicker" do
        expect(Hands::ThreeOfAKind.new(lower_hand) <=> Hands::ThreeOfAKind.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same three of a kind and first kicker but different second kicker" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "Q", suit: "Diamond")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Diamond")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher second kicker" do
        expect(Hands::ThreeOfAKind.new(higher_hand) <=> Hands::ThreeOfAKind.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower second kicker" do
        expect(Hands::ThreeOfAKind.new(lower_hand) <=> Hands::ThreeOfAKind.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing identical hands" do
      let(:hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "Q", suit: "Diamond")
        ], player_id: 1)
      end

      it "returns 0 when hands are identical" do
        expect(Hands::ThreeOfAKind.new(hand) <=> Hands::ThreeOfAKind.new(hand)).to eq(0)
      end
    end
  end
end
