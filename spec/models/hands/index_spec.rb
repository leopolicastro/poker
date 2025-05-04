require "rails_helper"

RSpec.describe Hands::Index, type: :model do
  subject { described_class.new(hand) }

  let(:deck) { create(:deck) }
  let(:cards) { (top_five + extras).shuffle }
  let(:other_cards) { (top_five2 + extras).shuffle }

  let(:extras) {
    [
      deck.cards.find_by(rank: "2", suit: "Spades"),
      deck.cards.find_by(rank: "3", suit: "Clubs")
    ]
  }

  let(:top_five) {
    [
      deck.cards.find_by(rank: "8", suit: "Hearts"),
      deck.cards.find_by(rank: "7", suit: "Spades"),
      deck.cards.find_by(rank: "10", suit: "Diamonds"),
      deck.cards.find_by(rank: "10", suit: "Clubs"),
      deck.cards.find_by(rank: "8", suit: "Spades")

    ]
  }
  let(:top_five2) {
    [
      deck.cards.find_by(rank: "4", suit: "Spades"),
      deck.cards.find_by(rank: "6", suit: "Hearts"),
      deck.cards.find_by(rank: "4", suit: "Hearts"),
      deck.cards.find_by(rank: "Jack", suit: "Clubs"),
      deck.cards.find_by(rank: "Queen", suit: "Spades")

    ]
  }
  let(:hand) { Hands::Hand.new(cards:, player_id: 1) }
  let(:other_hand) { Hands::Hand.new(cards: other_cards, player_id: 2) }

  describe "#<=>" do
    let(:other) { described_class.new(other_hand) }

    context "when comparing two hands with different levels" do
      it "returns the comparison of the levels" do
        expect((subject.<=> other)).to eq(1)
      end
    end

    context "when comparing two hands with the same level" do
      let(:other) { described_class.new(hand) }

      it "returns the comparison of the levels" do
        expect(subject.<=> other).to eq(0)
      end
    end
  end

  describe "#top_five" do
    it "returns the top five cards" do
      expect(subject.top_five.map(&:to_s)).to eq(["10 ♣", "10 ♦", "8 ♥", "8 ♠", "7 ♠"])
    end
  end

  describe ".points" do
    it "returns the sum of the top five cards" do
      expect(subject.points).to eq(43)
    end
  end

  # xdescribe "#>" do
  #   let(:other) { described_class.new(other_hand) }

  #   context "when comparing two hands with different levels" do
  #     it "returns the comparison of the levels" do
  #       expect(subject > other).to eq(true)
  #     end
  #   end

  #   context "when comparing two hands with the same level" do
  #     it "returns the comparison of the levels" do
  #       expect(subject > other).to eq(false)
  #     end
  #   end
  # end
end
