require "rails_helper"

RSpec.describe Hands::FullHouse, type: :model do
  let(:deck) { create(:deck) }
  let(:full_house) {
    [
      deck.cards.find_by(rank: "2", suit: "Heart"),
      deck.cards.find_by(rank: "2", suit: "Spade"),
      deck.cards.find_by(rank: "3", suit: "Diamond"),
      deck.cards.find_by(rank: "2", suit: "Club"),
      deck.cards.find_by(rank: "3", suit: "Heart")
    ]
  }
  let(:extras) {
    [
      deck.cards.find_by(rank: "8", suit: "Diamond"),
      deck.cards.find_by(rank: "7", suit: "Diamond")
    ]
  }
  let(:cards) { (full_house + extras).shuffle }
  let(:hand) { Hands::Hand.new(cards:, player_id: 1) }

  describe ".satisfied?" do
    context "when there are three cards with the same rank and two cards with the same rank" do
      it "returns true" do
        expect(described_class.satisfied?(hand)).to be_truthy
      end
    end

    context "when there are no three cards with the same rank and two cards with the same rank" do
      let(:full_house) {  # not a full house
        [
          deck.cards.find_by(rank: "2", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Spade"),
          deck.cards.find_by(rank: "8", suit: "Club"),
          deck.cards.find_by(rank: "3", suit: "Diamond"),
          deck.cards.find_by(rank: "3", suit: "Heart")
        ]
      }

      it "returns false" do
        hand = Hands::Hand.new(cards: cards, player_id: 1)

        expect(described_class.satisfied?(hand)).to be_falsey
      end
    end
  end

  describe ".top_five" do
    context "when there is only one possible full house" do
      it "returns the three highest cards with the same rank and the two highest cards with the same rank" do
        expect(described_class.top_five(hand).map(&:to_s)).to eq(["2 ♣", "2 ♥", "2 ♠", "3 ♦", "3 ♥"])
      end
    end

    context "when there are multiple possible full houses" do
      let(:full_house) {
        [
          deck.cards.find_by(rank: "8", suit: "Heart"),
          deck.cards.find_by(rank: "7", suit: "Spade"),
          deck.cards.find_by(rank: "8", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Club"),
          deck.cards.find_by(rank: "2", suit: "Heart")

        ]
      }

      it "returns the three highest cards with the same rank and the two highest cards with the same rank" do
        expect(described_class.top_five(hand).map(&:to_s)).to eq(["8 ♦", "8 ♦", "8 ♥", "7 ♦", "7 ♠"])
      end
    end
  end
end
