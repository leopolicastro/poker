require "rails_helper"

RSpec.describe Hands::Flush, type: :model do
  let(:deck) { create(:deck) }

  describe ".satisfied?" do
    it "returns true when 5 cards have the same suit" do
      hand = Hands::Hand.new cards: [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "3", suit: "Heart"),
        deck.cards.find_by(rank: "4", suit: "Heart"),
        deck.cards.find_by(rank: "5", suit: "Heart"),
        deck.cards.find_by(rank: "9", suit: "Heart"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Spade")
      ], player_id: 1

      expect(described_class.satisfied?(hand)).to be_truthy
    end

    it "returns false if less than 5 cards have the same suit" do
      hand = Hands::Hand.new cards: [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "3", suit: "Club"),
        deck.cards.find_by(rank: "4", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Diamond"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ], player_id: 1

      expect(described_class.satisfied?(hand)).to be_falsey
    end
  end
  let(:deck) { create(:deck) }
  let(:cards) { (top_five + extras).shuffle }
  let(:hand) { Hands::Hand.new(cards:, player_id: 1) }
  let(:extras) {
    [
      deck.cards.find_by(rank: "2", suit: "Spade"),
      deck.cards.find_by(rank: "K", suit: "Spade")
    ]
  }

  describe ".top_five" do
    context "there is only one possible flush" do
      let(:top_five) {
        [
          deck.cards.find_by(rank: "9", suit: "Spade"),
          deck.cards.find_by(rank: "4", suit: "Heart"),
          deck.cards.find_by(rank: "5", suit: "Spade"),
          deck.cards.find_by(rank: "7", suit: "Spade"),
          deck.cards.find_by(rank: "J", suit: "Heart")
        ].shuffle
      }

      it "returns the top five cards of the same suit" do
        expect(Hands::Flush.top_five(hand).map(&:to_s)).to eq(["K ♠", "9 ♠", "7 ♠", "5 ♠", "2 ♠"])
      end
    end
  end

  context "there are multiple possible flushes" do
    let(:top_five) {
      [
        deck.cards.find_by(rank: "9", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Spade"),
        deck.cards.find_by(rank: "7", suit: "Spade"),
        deck.cards.find_by(rank: "4", suit: "Spade"),
        deck.cards.find_by(rank: "J", suit: "Spade")

      ].shuffle
    }

    it "returns the top five cards of the same suit" do
      expect(Hands::Flush.top_five(hand).map(&:to_s)).to eq(["K ♠", "J ♠", "9 ♠", "7 ♠", "5 ♠"])
    end
  end

  describe "#<=>" do
    let(:deck) { create(:deck) }

    context "when comparing hands with different high cards" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Diamond"),
          deck.cards.find_by(rank: "7", suit: "Spade")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Heart"),
          deck.cards.find_by(rank: "10", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Diamond"),
          deck.cards.find_by(rank: "7", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher flush" do
        expect(Hands::Flush.new(higher_hand) <=> Hands::Flush.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower flush" do
        expect(Hands::Flush.new(lower_hand) <=> Hands::Flush.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same high card but different second card" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Diamond"),
          deck.cards.find_by(rank: "7", suit: "Spade")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Heart"),
          deck.cards.find_by(rank: "10", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Diamond"),
          deck.cards.find_by(rank: "7", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher second card" do
        expect(Hands::Flush.new(higher_hand) <=> Hands::Flush.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower second card" do
        expect(Hands::Flush.new(lower_hand) <=> Hands::Flush.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same first two cards but different third card" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Diamond"),
          deck.cards.find_by(rank: "7", suit: "Spade")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Heart"),
          deck.cards.find_by(rank: "10", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Diamond"),
          deck.cards.find_by(rank: "7", suit: "Spade")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher third card" do
        expect(Hands::Flush.new(higher_hand) <=> Hands::Flush.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower third card" do
        expect(Hands::Flush.new(lower_hand) <=> Hands::Flush.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing identical hands" do
      let(:hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "Q", suit: "Heart"),
          deck.cards.find_by(rank: "J", suit: "Heart"),
          deck.cards.find_by(rank: "9", suit: "Heart"),
          deck.cards.find_by(rank: "8", suit: "Diamond"),
          deck.cards.find_by(rank: "7", suit: "Spade")
        ], player_id: 1)
      end

      it "returns 0 when hands are identical" do
        expect(Hands::Flush.new(hand) <=> Hands::Flush.new(hand)).to eq(0)
      end
    end
  end
end
