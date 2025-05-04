require "rails_helper"

RSpec.describe Hands::HighCard, type: :model do
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
      deck.cards.find_by(rank: "7", suit: "Spades"),
      deck.cards.find_by(rank: "10", suit: "Diamonds"),
      deck.cards.find_by(rank: "9", suit: "Clubs"),
      deck.cards.find_by(rank: "8", suit: "Spades")
    ]
  }
  let(:hand) { Hands::Hand.new(cards:, player_id: 1) }

  describe "#top_five" do
    context "when the 10 is the highest card" do
      it "returns the top five cards" do
        expect(Hands::HighCard.top_five(hand).map(&:to_s)).to eq(["10 ♦", "9 ♣", "8 ♠", "7 ♠", "5 ♥"])
      end
    end

    context "when the Ace is the highest card" do
      let(:extras) {
        [
          deck.cards.find_by(rank: "Ace", suit: "Spades"),
          deck.cards.find_by(rank: "King", suit: "Clubs")
        ]
      }

      it "returns the top five cards" do
        expect(Hands::HighCard.top_five(hand).map(&:to_s)).to eq(["Ace ♠", "King ♣", "10 ♦", "9 ♣", "8 ♠"])
      end
    end
  end
end
