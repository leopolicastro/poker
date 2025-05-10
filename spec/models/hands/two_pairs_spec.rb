require "rails_helper"

RSpec.describe Hands::TwoPairs, type: :model do
  let(:deck) { create(:deck) }

  describe ".satisfied?" do
    it "returns true if the cards have two pairs" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "7", suit: "Heart"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "7", suit: "Spade"),
        deck.cards.find_by(rank: "9", suit: "Diamond"),
        deck.cards.find_by(rank: "2", suit: "Diamond"),
        deck.cards.find_by(rank: "3", suit: "Diamond"),
        deck.cards.find_by(rank: "4", suit: "Diamond")

      ], player_id: 1)

      expect(described_class.satisfied?(cards)).to eq(true)
    end

    it "returns false if the cards don't have two pairs" do
      cards = Hands::Hand.new cards: [
        deck.cards.find_by(rank: "7", suit: "Heart"),
        deck.cards.find_by(rank: "8", suit: "Spade"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "10", suit: "Diamond"),
        deck.cards.find_by(rank: "2", suit: "Diamond"),
        deck.cards.find_by(rank: "3", suit: "Diamond"),
        deck.cards.find_by(rank: "4", suit: "Diamond")
      ], player_id: 1

      expect(described_class.satisfied?(cards)).to eq(false)
    end

    it "returns false if the cards only have one pair" do
      cards = Hands::Hand.new cards: [
        deck.cards.find_by(rank: "7", suit: "Heart"),
        deck.cards.find_by(rank: "7", suit: "Spade"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "10", suit: "Diamond"),
        deck.cards.find_by(rank: "2", suit: "Diamond"),
        deck.cards.find_by(rank: "3", suit: "Diamond"),
        deck.cards.find_by(rank: "4", suit: "Diamond")
      ], player_id: 1

      expect(described_class.satisfied?(cards)).to eq(false)
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
        deck.cards.find_by(rank: "5", suit: "Heart"),
        deck.cards.find_by(rank: "5", suit: "Spade"),
        deck.cards.find_by(rank: "10", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "9", suit: "Spade")

      ]
    }
    let(:hand) { Hands::Hand.new(cards:, player_id: 1) }

    describe "#top_five" do
      it "returns the top five cards" do
        expect(Hands::TwoPairs.top_five(hand).map(&:to_s)).to eq(["5 ♥", "5 ♠", "9 ♣", "9 ♠", "10 ♦"])
      end
    end
  end
end
