require "rails_helper"

RSpec.describe Hands::HighCard, type: :model do
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
      deck.cards.find_by(rank: "7", suit: "Spade"),
      deck.cards.find_by(rank: "10", suit: "Diamond"),
      deck.cards.find_by(rank: "9", suit: "Club"),
      deck.cards.find_by(rank: "8", suit: "Spade")
    ]
  }
  let(:hand) { Hands::Hand.new(cards:, player_id: 1) }

  describe "#top_five" do
    context "when the 10 is the highest card" do
      it "returns the top five cards" do
        expect(Hands::HighCard.top_five(hand).map(&:to_s)).to eq(["10 ♦", "9 ♣", "8 ♠", "7 ♠", "5 ♥"])
      end
    end

    context "when the A is the highest card" do
      let(:extras) {
        [
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "K", suit: "Club")
        ]
      }

      it "returns the top five cards" do
        expect(Hands::HighCard.top_five(hand).map(&:to_s)).to eq(["A ♠", "K ♣", "10 ♦", "9 ♣", "8 ♠"])
      end
    end
  end
end
