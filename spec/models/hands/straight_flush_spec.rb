require "rails_helper"

RSpec.describe Hands::StraightFlush, type: :model do
  let(:deck) { create(:deck) }

  describe ".satisfied?" do
    it "returns true when the cards are in consecutive order and have the same suit" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "3", suit: "Heart"),
        deck.cards.find_by(rank: "4", suit: "Heart"),
        deck.cards.find_by(rank: "5", suit: "Heart"),
        deck.cards.find_by(rank: "6", suit: "Heart"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "10", suit: "Spade")
      ], player_id: 1)

      expect(described_class.satisfied?(cards)).to be_truthy
    end

    it "returns false when there is a flush but there isn't a straight" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "3", suit: "Diamond"),
        deck.cards.find_by(rank: "4", suit: "Diamond"),
        deck.cards.find_by(rank: "5", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Heart"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Diamond")
      ], player_id: 1)

      expect(described_class.satisfied?(cards)).to be_falsey
    end

    it "returns false when there is a straight but there isn't a flush" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "3", suit: "Club"),
        deck.cards.find_by(rank: "4", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Diamond"),
        deck.cards.find_by(rank: "6", suit: "Heart"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "10", suit: "Spade")
      ], player_id: 1)

      expect(described_class.satisfied?(cards)).to be_falsey
    end
  end

  describe ".top_five" do
    let(:cards) { (top_five + extras).shuffle }

    let(:extras) {
      [
        deck.cards.find_by(rank: "2", suit: "Spade"),
        deck.cards.find_by(rank: "3", suit: "Spade")
      ]
    }

    let(:top_five) {
      [
        deck.cards.find_by(rank: "4", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Spade"),
        deck.cards.find_by(rank: "6", suit: "Spade"),
        deck.cards.find_by(rank: "9", suit: "Club"),
        deck.cards.find_by(rank: "10", suit: "Spade")

      ]
    }
    let(:hand) { Hands::Hand.new(cards:, player_id: 1) }

    context "when its not a ace low straight flush" do
      it "returns the five highest cards in consecutive order with the same suit" do
        expect(described_class.top_five(hand).map(&:to_s)).to eq(["2 ♠", "3 ♠", "4 ♠", "5 ♠", "6 ♠"])
      end
    end
  end
end
