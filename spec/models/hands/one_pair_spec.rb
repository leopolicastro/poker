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

  describe "#<=>" do
    context "when comparing hands with different pair values" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "K", suit: "Club"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Diamond")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "K", suit: "Heart"),
          deck.cards.find_by(rank: "K", suit: "Spade"),
          deck.cards.find_by(rank: "A", suit: "Club"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Diamond")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher pair" do
        expect(Hands::OnePair.new(higher_hand) <=> Hands::OnePair.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower pair" do
        expect(Hands::OnePair.new(lower_hand) <=> Hands::OnePair.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same pair but different kickers" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "K", suit: "Club"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Diamond")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "Q", suit: "Club"),
          deck.cards.find_by(rank: "J", suit: "Diamond"),
          deck.cards.find_by(rank: "10", suit: "Diamond")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher kickers" do
        expect(Hands::OnePair.new(higher_hand) <=> Hands::OnePair.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower kickers" do
        expect(Hands::OnePair.new(lower_hand) <=> Hands::OnePair.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing hands with same pair and first kicker but different second kicker" do
      let(:higher_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "K", suit: "Club"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Diamond")
        ], player_id: 1)
      end

      let(:lower_hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "K", suit: "Club"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "10", suit: "Diamond")
        ], player_id: 2)
      end

      it "returns 1 when first hand has higher second kicker" do
        expect(Hands::OnePair.new(higher_hand) <=> Hands::OnePair.new(lower_hand)).to eq(1)
      end

      it "returns -1 when first hand has lower second kicker" do
        expect(Hands::OnePair.new(lower_hand) <=> Hands::OnePair.new(higher_hand)).to eq(-1)
      end
    end

    context "when comparing identical hands" do
      let(:hand) do
        Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "A", suit: "Heart"),
          deck.cards.find_by(rank: "A", suit: "Spade"),
          deck.cards.find_by(rank: "K", suit: "Club"),
          deck.cards.find_by(rank: "Q", suit: "Diamond"),
          deck.cards.find_by(rank: "J", suit: "Diamond")
        ], player_id: 1)
      end

      it "returns 0 when hands are identical" do
        expect(Hands::OnePair.new(hand) <=> Hands::OnePair.new(hand)).to eq(0)
      end
    end
  end
end
