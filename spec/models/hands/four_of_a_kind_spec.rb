require "rails_helper"

RSpec.describe Hands::FourOfAKind, type: :model do
  let(:deck) { create(:deck) }
  let(:cards) { (top_five + extras).shuffle }

  let(:extras) {
    [
      deck.cards.find_by(rank: "2", suit: "Spades"),
      deck.cards.find_by(rank: "9", suit: "Diamonds")
    ]
  }

  let(:top_five) {
    [
      deck.cards.find_by(rank: "9", suit: "Spades"),
      deck.cards.find_by(rank: "9", suit: "Hearts"),
      deck.cards.find_by(rank: "9", suit: "Clubs"),
      deck.cards.find_by(rank: "10", suit: "Diamonds"),
      deck.cards.find_by(rank: "4", suit: "Spades")

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
          deck.cards.find_by(rank: "9", suit: "Spades"),
          deck.cards.find_by(rank: "9", suit: "Hearts"),
          deck.cards.find_by(rank: "8", suit: "Clubs"),
          deck.cards.find_by(rank: "10", suit: "Diamonds"),
          deck.cards.find_by(rank: "4", suit: "Spades")
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
          deck.cards.find_by(rank: "Ace", suit: "Spades"),
          deck.cards.find_by(rank: "9", suit: "Diamonds")
        ]
      }

      it "returns the four cards with the same rank and the next highest card" do
        expect(described_class.top_five(hand).map(&:to_s)).to eq(["9 ♣", "9 ♦", "9 ♥", "9 ♠", "Ace ♠"])
      end
    end
  end
end
