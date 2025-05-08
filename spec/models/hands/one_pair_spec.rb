require "rails_helper"

RSpec.describe Hands::OnePair, type: :model do
  let(:deck) { create(:deck) }

  describe ".satisfied?" do
    it "returns true if the cards have one pair" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "7", suit: "Heart"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "7", suit: "Spade"),
        deck.cards.find_by(rank: "10", suit: "Diamond"),
        deck.cards.find_by(rank: "3", suit: "Club"),
        deck.cards.find_by(rank: "2", suit: "Spade"),
        deck.cards.find_by(rank: "8", suit: "Spade")
      ], player_id: 1)

      expect(Hands::OnePair.satisfied?(cards)).to eq(true)
    end

    it "returns false if the cards don't have one pair" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "7", suit: "Heart"),
        deck.cards.find_by(rank: "8", suit: "Spade"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "10", suit: "Diamond"),
        deck.cards.find_by(rank: "3", suit: "Club"),
        deck.cards.find_by(rank: "4", suit: "Spade")
      ], player_id: 1)

      expect(Hands::OnePair.satisfied?(cards)).to eq(false)
    end
  end

  describe ".top_five" do
    let(:cards) { (top_five + extras).shuffle }

    let(:extras) {
      [
        deck.cards.find_by(rank: "2", suit: "Spade"),
        deck.cards.find_by(rank: "3", suit: "Club")
      ]
    }

    let(:top_five) {
      [
        deck.cards.find_by(rank: "7", suit: "Heart"),
        deck.cards.find_by(rank: "7", suit: "Spade"),
        deck.cards.find_by(rank: "10", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "8", suit: "Spade")

      ]
    }
    let(:hand) { Hands::Hand.new(cards:, player_id: 1) }

    it "returns the top five cards for a hand with one pair" do
      expect(Hands::OnePair.top_five(hand).map(&:to_s)).to eq(["7 ♥", "7 ♠", "10 ♦", "9 ♣", "8 ♠"])
    end
  end
end
