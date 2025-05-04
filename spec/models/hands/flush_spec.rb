require "rails_helper"

RSpec.describe Hands::Flush, type: :model do
  let(:deck) { create(:deck) }

  describe ".satisfied?" do
    it "returns true when 5 cards have the same suit" do
      hand = Hands::Hand.new cards: [
        deck.cards.find_by(rank: "2", suit: "Hearts"),
        deck.cards.find_by(rank: "3", suit: "Hearts"),
        deck.cards.find_by(rank: "4", suit: "Hearts"),
        deck.cards.find_by(rank: "5", suit: "Hearts"),
        deck.cards.find_by(rank: "9", suit: "Hearts"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "7", suit: "Spades")
      ], player_id: 1

      expect(described_class.satisfied?(hand)).to be_truthy
    end

    it "returns false if less than 5 cards have the same suit" do
      hand = Hands::Hand.new cards: [
        deck.cards.find_by(rank: "2", suit: "Hearts"),
        deck.cards.find_by(rank: "3", suit: "Clubs"),
        deck.cards.find_by(rank: "4", suit: "Spades"),
        deck.cards.find_by(rank: "5", suit: "Diamonds"),
        deck.cards.find_by(rank: "9", suit: "Diamonds"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "7", suit: "Diamonds")
      ], player_id: 1

      expect(described_class.satisfied?(hand)).to be_falsey
    end
  end
  let(:deck) { create(:deck) }
  let(:cards) { (top_five + extras).shuffle }
  let(:hand) { Hands::Hand.new(cards:, player_id: 1) }
  let(:extras) {
    [
      deck.cards.find_by(rank: "2", suit: "Spades"),
      deck.cards.find_by(rank: "King", suit: "Spades")
    ]
  }

  describe ".top_five" do
    context "there is only one possible flush" do
      let(:top_five) {
        [
          deck.cards.find_by(rank: "9", suit: "Spades"),
          deck.cards.find_by(rank: "4", suit: "Hearts"),
          deck.cards.find_by(rank: "5", suit: "Spades"),
          deck.cards.find_by(rank: "7", suit: "Spades"),
          deck.cards.find_by(rank: "Jack", suit: "Hearts")
        ].shuffle
      }

      it "returns the top five cards of the same suit" do
        expect(Hands::Flush.top_five(hand).map(&:to_s)).to eq(["King ♠", "9 ♠", "7 ♠", "5 ♠", "2 ♠"])
      end
    end
  end

  context "there are multiple possible flushes" do
    let(:top_five) {
      [
        deck.cards.find_by(rank: "9", suit: "Spades"),
        deck.cards.find_by(rank: "5", suit: "Spades"),
        deck.cards.find_by(rank: "7", suit: "Spades"),
        deck.cards.find_by(rank: "4", suit: "Spades"),
        deck.cards.find_by(rank: "Jack", suit: "Spades")

      ].shuffle
    }

    it "returns the top five cards of the same suit" do
      expect(Hands::Flush.top_five(hand).map(&:to_s)).to eq(["King ♠", "Jack ♠", "9 ♠", "7 ♠", "5 ♠"])
    end
  end
end
