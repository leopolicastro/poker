require "rails_helper"

RSpec.describe Hands::Straight, type: :model do
  let(:deck) { create(:deck) }

  describe ".satisfied?" do
    context "when the Ace is high" do
      it "returns true when the cards are in consecutive order" do
        hand = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "2", suit: "Hearts"),
          deck.cards.find_by(rank: "3", suit: "Clubs"),
          deck.cards.find_by(rank: "4", suit: "Spades"),
          deck.cards.find_by(rank: "5", suit: "Diamonds"),
          deck.cards.find_by(rank: "6", suit: "Hearts"),
          deck.cards.find_by(rank: "9", suit: "Clubs"),
          deck.cards.find_by(rank: "10", suit: "Spades")
        ], player_id: 1)

        expect(described_class.satisfied?(hand)).to be_truthy
      end

      it "returns false when the cards are not in consecutive order" do
        cards = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "2", suit: "Hearts"),
          deck.cards.find_by(rank: "3", suit: "Clubs"),
          deck.cards.find_by(rank: "4", suit: "Spades"),
          deck.cards.find_by(rank: "5", suit: "Diamonds"),
          deck.cards.find_by(rank: "7", suit: "Hearts"),
          deck.cards.find_by(rank: "8", suit: "Diamonds"),
          deck.cards.find_by(rank: "9", suit: "Diamonds")
        ], player_id: 1)

        expect(described_class.satisfied?(cards)).to be_falsey
      end
    end

    context "when the Ace is low" do
      it "returns true if the cards are in consecutive order" do
        hand = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "Ace", suit: "Hearts"),
          deck.cards.find_by(rank: "2", suit: "Clubs"),
          deck.cards.find_by(rank: "3", suit: "Spades"),
          deck.cards.find_by(rank: "4", suit: "Diamonds"),
          deck.cards.find_by(rank: "5", suit: "Hearts"),
          deck.cards.find_by(rank: "8", suit: "Clubs"),
          deck.cards.find_by(rank: "9", suit: "Clubs")
        ], player_id: 1)

        expect(described_class.satisfied?(hand)).to be_truthy
      end

      it "returns false if the cards are not in consecutive order" do
        cards = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "Ace", suit: "Hearts"),
          deck.cards.find_by(rank: "2", suit: "Clubs"),
          deck.cards.find_by(rank: "3", suit: "Spades"),
          deck.cards.find_by(rank: "4", suit: "Diamonds"),
          deck.cards.find_by(rank: "6", suit: "Hearts"),
          deck.cards.find_by(rank: "7", suit: "Diamonds"),
          deck.cards.find_by(rank: "8", suit: "Diamonds")
        ], player_id: 1)

        expect(described_class.satisfied?(cards)).to be_falsey
      end
    end
  end

  describe ".top_five" do
    context "when the Ace is low" do
      it "returns the top five consecutive cards" do
        cards = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "Ace", suit: "Hearts"),
          deck.cards.find_by(rank: "2", suit: "Clubs"),
          deck.cards.find_by(rank: "3", suit: "Spades"),
          deck.cards.find_by(rank: "4", suit: "Diamonds"),
          deck.cards.find_by(rank: "5", suit: "Hearts"),
          deck.cards.find_by(rank: "8", suit: "Clubs"),
          deck.cards.find_by(rank: "9", suit: "Clubs")
        ].shuffle, player_id: 1)

        expect(described_class.top_five(cards).map(&:to_s)).to eq(["Ace ♥", "2 ♣", "3 ♠", "4 ♦", "5 ♥"])
      end
    end

    context "when the Ace is high" do
      it "returns the top five consecutive cards 2,3,4,5,6" do
        hand = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "2", suit: "Hearts"),
          deck.cards.find_by(rank: "9", suit: "Clubs"),
          deck.cards.find_by(rank: "4", suit: "Spades"),
          deck.cards.find_by(rank: "5", suit: "Diamonds"),
          deck.cards.find_by(rank: "3", suit: "Clubs"),
          deck.cards.find_by(rank: "10", suit: "Spades"),
          deck.cards.find_by(rank: "6", suit: "Hearts")
        ].shuffle, player_id: 1)

        expect(described_class.top_five(hand).map(&:to_s)).to eq(["2 ♥", "3 ♣", "4 ♠", "5 ♦", "6 ♥"])
      end

      it "returns the top five consecutive cards 10, Jack, Queen, King, Ace" do
        hand = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "Ace", suit: "Hearts"),
          deck.cards.find_by(rank: "King", suit: "Clubs"),
          deck.cards.find_by(rank: "Queen", suit: "Spades"),
          deck.cards.find_by(rank: "Jack", suit: "Diamonds"),
          deck.cards.find_by(rank: "10", suit: "Hearts"),
          deck.cards.find_by(rank: "9", suit: "Clubs"),
          deck.cards.find_by(rank: "8", suit: "Spades")
        ].shuffle, player_id: 1)

        expect(described_class.top_five(hand).map(&:to_s)).to eq(["10 ♥", "Jack ♦", "Queen ♠", "King ♣", "Ace ♥"])
      end

      it "returns the top five consecutive cards 8,9, 10, Jack, Queen" do
        hand = Hands::Hand.new(cards: [
          deck.cards.find_by(rank: "Ace", suit: "Hearts"),
          deck.cards.find_by(rank: "Queen", suit: "Spades"),
          deck.cards.find_by(rank: "5", suit: "Clubs"),
          deck.cards.find_by(rank: "10", suit: "Hearts"),
          deck.cards.find_by(rank: "Jack", suit: "Diamonds"),
          deck.cards.find_by(rank: "9", suit: "Clubs"),
          deck.cards.find_by(rank: "8", suit: "Spades")
        ].shuffle, player_id: 1)

        expect(described_class.top_five(hand).map(&:to_s)).to eq(["8 ♠", "9 ♣", "10 ♥", "Jack ♦", "Queen ♠"])
      end
    end
  end
end
