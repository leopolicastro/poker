require "rails_helper"

RSpec.describe Hands::FourOfAKind, type: :model do
  let(:deck) { create(:deck) }
  let(:cards) { (top_five + extras).shuffle }

  let(:extras) {
    [
      deck.cards.find_by(rank: "2", suit: "Spade"),
      deck.cards.find_by(rank: "9", suit: "Diamond")
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

  describe ".satisfied?" do
    context "when there are four cards with the same rank" do
      it "returns true" do
        expect(described_class.satisfied?(hand)).to be_truthy
      end
    end

    context "when there are no four cards with the same rank" do
      let(:top_five) {  # not four of a kind
        [
          deck.cards.find_by(rank: "9", suit: "Spade"),
          deck.cards.find_by(rank: "9", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Club"),
          deck.cards.find_by(rank: "10", suit: "Diamond"),
          deck.cards.find_by(rank: "4", suit: "Spade")
        ]
      }

      it "returns false" do
        expect(described_class.satisfied?(hand)).to be_falsey
      end
    end
  end

  describe ".top_five" do
    it "returns the four cards with the same rank and the next highest card" do
      expect(described_class.top_five(hand).map(&:to_s)).to eq(["9 ♣", "9 ♦", "9 ♥", "9 ♠", "10 ♦"])
    end

    context "with an A kicker" do
      let(:extras) {
        [
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "9", suit: "Diamond")
        ]
      }

      it "returns the four cards with the same rank and the next highest card" do
        expect(described_class.top_five(hand).map(&:to_s)).to eq(["9 ♣", "9 ♦", "9 ♥", "9 ♠", "A ♠"])
      end
    end
  end

  describe "#<=>" do
    let(:deck) { create(:deck) }

    context "when comparing hands with different four of a kind values" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Spade"),
          deck.cards.find_by(rank: "K", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher four of a kind" do
        expect(Hands::FourOfAKind.new(higher_hand) <=> Hands::FourOfAKind.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower four of a kind" do
        expect(Hands::FourOfAKind.new(lower_hand) <=> Hands::FourOfAKind.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same four of a kind but different kickers" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "Q", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Diamond"),
          deck.cards.find_by(rank: "10", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher kicker" do
        expect(Hands::FourOfAKind.new(higher_hand) <=> Hands::FourOfAKind.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower kicker" do
        expect(Hands::FourOfAKind.new(lower_hand) <=> Hands::FourOfAKind.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same four of a kind and kicker but different suits" do
      let(:hand1) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 1)
      end

      let(:hand2) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "Q", suit: "Club"),
          deck.cards.find_by(rank: "J", suit: "Heart")
        ], player_id: 2)
      end

      it "returns 0 when hands have same ranks but different suits" do
        expect(Hands::FourOfAKind.new(hand1) <=> Hands::FourOfAKind.new(hand2)).to eq(0)
      end
    end

    context "when comparing identical hands" do
      let(:hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 1)
      end

      it "returns 0 when hands are identical" do
        expect(Hands::FourOfAKind.new(hand) <=> Hands::FourOfAKind.new(hand)).to eq(0)
      end
    end
  end
end
