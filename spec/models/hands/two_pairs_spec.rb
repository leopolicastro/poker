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

    it "returns true with Aces and Kings as pairs" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "A", suit: "Heart"),
        deck.cards.find_by(rank: "A", suit: "Spade"),
        deck.cards.find_by(rank: "K", suit: "Club"),
        deck.cards.find_by(rank: "K", suit: "Diamond"),
        deck.cards.find_by(rank: "Q", suit: "Diamond"),
        deck.cards.find_by(rank: "J", suit: "Diamond"),
        deck.cards.find_by(rank: "10", suit: "Diamond")
      ], player_id: 1)

      expect(described_class.satisfied?(cards)).to eq(true)
    end

    it "returns true with Aces and Tens as pairs" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "A", suit: "Heart"),
        deck.cards.find_by(rank: "A", suit: "Spade"),
        deck.cards.find_by(rank: "10", suit: "Club"),
        deck.cards.find_by(rank: "10", suit: "Diamond"),
        deck.cards.find_by(rank: "K", suit: "Diamond"),
        deck.cards.find_by(rank: "Q", suit: "Diamond"),
        deck.cards.find_by(rank: "J", suit: "Diamond")
      ], player_id: 1)

      expect(described_class.satisfied?(cards)).to eq(true)
    end

    it "returns true with three pairs (should still be valid two pair)" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "A", suit: "Heart"),
        deck.cards.find_by(rank: "A", suit: "Spade"),
        deck.cards.find_by(rank: "K", suit: "Club"),
        deck.cards.find_by(rank: "K", suit: "Diamond"),
        deck.cards.find_by(rank: "Q", suit: "Heart"),
        deck.cards.find_by(rank: "Q", suit: "Spade"),
        deck.cards.find_by(rank: "J", suit: "Diamond")
      ], player_id: 1)

      expect(described_class.satisfied?(cards)).to eq(true)
    end

    it "returns true with mixed high and low pairs" do
      cards = Hands::Hand.new(cards: [
        deck.cards.find_by(rank: "A", suit: "Heart"),
        deck.cards.find_by(rank: "A", suit: "Spade"),
        deck.cards.find_by(rank: "2", suit: "Club"),
        deck.cards.find_by(rank: "2", suit: "Diamond"),
        deck.cards.find_by(rank: "K", suit: "Diamond"),
        deck.cards.find_by(rank: "Q", suit: "Diamond"),
        deck.cards.find_by(rank: "J", suit: "Diamond")
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

  describe "#<=>" do
    let(:deck) { create(:deck) }

    context "when comparing hands with different high pairs" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "7", suit: "Club"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "7", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Diamond"),
          deck.cards.find_by(rank: "A", suit: "Heart")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "K", suit: "Spade"),
          deck.cards.find_by(rank: "7", suit: "Club"),
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "7", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Diamond")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher pairs" do
        expect(Hands::TwoPairs.new(higher_hand) <=> Hands::TwoPairs.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower pairs" do
        expect(Hands::TwoPairs.new(lower_hand) <=> Hands::TwoPairs.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same high pair but different low pairs" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "8", suit: "Club"),
          deck.cards.find_by(rank: "8", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Diamond")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "7", suit: "Club"),
          deck.cards.find_by(rank: "7", suit: "Diamond"),
          deck.cards.find_by(rank: "2", suit: "Diamond")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher low pair" do
        expect(Hands::TwoPairs.new(higher_hand) <=> Hands::TwoPairs.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower low pair" do
        expect(Hands::TwoPairs.new(lower_hand) <=> Hands::TwoPairs.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same pairs but different kickers" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "7", suit: "Club"),
          deck.cards.find_by(rank: "7", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Diamond")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "7", suit: "Club"),
          deck.cards.find_by(rank: "7", suit: "Diamond"),
          deck.cards.find_by(rank: "Q", suit: "Diamond")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher kicker" do
        expect(Hands::TwoPairs.new(higher_hand) <=> Hands::TwoPairs.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower kicker" do
        expect(Hands::TwoPairs.new(lower_hand) <=> Hands::TwoPairs.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing identical hands" do
      let(:hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "7", suit: "Club"),
          deck.cards.find_by(rank: "7", suit: "Diamond"),
          deck.cards.find_by(rank: "K", suit: "Diamond")
        ], player_id: 1)
      end

      it "returns 0 when hands are identical" do
        expect(Hands::TwoPairs.new(hand) <=> Hands::TwoPairs.new(hand)).to eq(0)
      end
    end
  end
end
