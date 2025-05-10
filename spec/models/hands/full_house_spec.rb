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

  describe "#<=>" do
    let(:deck) { create(:deck) }

    context "when comparing hands with different three of a kind values" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Spade"),
          deck.cards.find_by(rank: "K", suit: "Club"),
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher three of a kind" do
        expect(Hands::FullHouse.new(higher_hand) <=> Hands::FullHouse.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower three of a kind" do
        expect(Hands::FullHouse.new(lower_hand) <=> Hands::FullHouse.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same three of a kind but different pair values" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "Q", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher pair" do
        expect(Hands::FullHouse.new(higher_hand) <=> Hands::FullHouse.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower pair" do
        expect(Hands::FullHouse.new(lower_hand) <=> Hands::FullHouse.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same three of a kind and pair values but different suits" do
      let(:hand1) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 1)
      end

      let(:hand2) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Diamond"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "K", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Spade"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 0 when hands have same ranks but different suits" do
        expect(Hands::FullHouse.new(hand1) <=> Hands::FullHouse.new(hand2)).to eq(0)
      end
    end

    context "when comparing identical hands" do
      let(:hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Spade")
        ], player_id: 1)
      end

      it "returns 0 when hands are identical" do
        expect(Hands::FullHouse.new(hand) <=> Hands::FullHouse.new(hand)).to eq(0)
      end
    end
  end
end
