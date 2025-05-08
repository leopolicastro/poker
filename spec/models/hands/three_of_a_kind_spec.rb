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
end
