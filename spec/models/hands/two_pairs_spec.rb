require "rails_helper"

RSpec.describe Hands::TwoPairs, type: :model do
  let(:deck) { create(:deck) }

  describe ".satisfied?" do
    it "returns true if the cards have two pairs" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "7", suit: "Hearts"),
        deck.cards.find_by(rank: "9", suit: "Clubs"),
        deck.cards.find_by(rank: "7", suit: "Spades"),
        deck.cards.find_by(rank: "9", suit: "Diamonds"),
        deck.cards.find_by(rank: "2", suit: "Diamonds"),
        deck.cards.find_by(rank: "3", suit: "Diamonds"),
        deck.cards.find_by(rank: "4", suit: "Diamonds")

      ], player_id: 1)

      expect(described_class.satisfied?(cards)).to eq(true)
    end

    it "returns false if the cards don't have two pairs" do
      cards = Hands::Hand.new cards: [
        deck.cards.find_by(rank: "7", suit: "Hearts"),
        deck.cards.find_by(rank: "8", suit: "Spades"),
        deck.cards.find_by(rank: "9", suit: "Clubs"),
        deck.cards.find_by(rank: "10", suit: "Diamonds"),
        deck.cards.find_by(rank: "2", suit: "Diamonds"),
        deck.cards.find_by(rank: "3", suit: "Diamonds"),
        deck.cards.find_by(rank: "4", suit: "Diamonds")
      ], player_id: 1

      expect(described_class.satisfied?(cards)).to eq(false)
    end

    it "returns false if the cards only have one pair" do
      cards = Hands::Hand.new cards: [
        deck.cards.find_by(rank: "7", suit: "Hearts"),
        deck.cards.find_by(rank: "7", suit: "Spades"),
        deck.cards.find_by(rank: "9", suit: "Clubs"),
        deck.cards.find_by(rank: "10", suit: "Diamonds"),
        deck.cards.find_by(rank: "2", suit: "Diamonds"),
        deck.cards.find_by(rank: "3", suit: "Diamonds"),
        deck.cards.find_by(rank: "4", suit: "Diamonds")
      ], player_id: 1

      expect(described_class.satisfied?(cards)).to eq(false)
    end
  end

  describe ".top_five" do
    let(:deck) { create(:deck) }
    let(:cards) { (top_five + extras).shuffle }

    let(:extras) {
      [
        deck.cards.find_by(rank: "2", suit: "Spades"),
        deck.cards.find_by(rank: "3", suit: "Clubs")
      ]
    }

    let(:top_five) {
      [
        deck.cards.find_by(rank: "5", suit: "Hearts"),
        deck.cards.find_by(rank: "5", suit: "Spades"),
        deck.cards.find_by(rank: "10", suit: "Diamonds"),
        deck.cards.find_by(rank: "9", suit: "Clubs"),
        deck.cards.find_by(rank: "9", suit: "Spades")

      ]
    }
    let(:hand) { Hands::Hand.new(cards:, player_id: 1) }

    describe "#top_five" do
      it "returns the top five cards" do
        expect(Hands::TwoPairs.top_five(hand).map(&:to_s)).to eq(["9 ♣", "9 ♠", "5 ♥", "5 ♠", "10 ♦"])
      end
    end
  end
end
