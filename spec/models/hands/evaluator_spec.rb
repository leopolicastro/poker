require "rails_helper"

RSpec.describe Hands::Evaluator, type: :module do
  let(:game) { create(:game) }
  let(:player1) { create(:player, game:) }
  let(:player2) { create(:player, game:) }
  let(:deck) { create(:deck, deckable: game) }

  let(:board) {
    [
      deck.cards.find_by(rank: "2", suit: "Spades"),
      deck.cards.find_by(rank: "3", suit: "Clubs"),
      deck.cards.find_by(rank: "4", suit: "Spades"),
      deck.cards.find_by(rank: "7", suit: "Clubs"),
      deck.cards.find_by(rank: "9", suit: "Clubs")
    ]
  }
  let(:player2_cards) { [] }

  before do
    cards.each do |card|
      card.update!(cardable: player1)
    end
  end

  before do
    player2_cards.each do |card|
      card.update!(cardable: player2)
    end
  end

  describe ".find_top_hands" do
    context "when the best hand is a pair" do
      let(:board) {
        [
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "4", suit: "Clubs"),
          deck.cards.find_by(rank: "7", suit: "Spades"),
          deck.cards.find_by(rank: "8", suit: "Clubs"),
          deck.cards.find_by(rank: "10", suit: "Clubs")
        ]
      }
      let(:cards) {
        [
          deck.cards.find_by(rank: "6", suit: "Hearts"),
          deck.cards.find_by(rank: "8", suit: "Hearts")
        ]
      }
      let(:hands) { [Hands::Hand.new(cards:, player_id: player1.id)] }

      describe ".find_top_hands" do
        it "returns the top hands for each player" do
          top_hands = described_class.find_top_hands(hands, board)

          expect(top_hands[player1.id].level).to eq(Hands::OnePair)
        end
      end
    end

    context "when the best hand is two pairs" do
      let(:board) {
        [
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "4", suit: "Clubs"),
          deck.cards.find_by(rank: "6", suit: "Spades"),
          deck.cards.find_by(rank: "8", suit: "Clubs"),
          deck.cards.find_by(rank: "10", suit: "Clubs")
        ]
      }
      let(:cards) {
        [
          deck.cards.find_by(rank: "6", suit: "Hearts"),
          deck.cards.find_by(rank: "8", suit: "Hearts")
        ]
      }
      let(:hands) {
        [
          Hands::Hand.new(cards:, player_id: player1.id)
        ]
      }

      describe ".find_top_hands" do
        it "returns the top hands for each player" do
          top_hands = described_class.find_top_hands(hands, board)

          expect(top_hands[player1.id].level).to eq(Hands::TwoPairs)
        end
      end
    end

    context "when the best hand is a three of a kind" do
      let(:board) {
        [
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "4", suit: "Clubs"),
          deck.cards.find_by(rank: "6", suit: "Spades"),
          deck.cards.find_by(rank: "8", suit: "Clubs"),
          deck.cards.find_by(rank: "10", suit: "Clubs")
        ]
      }
      let(:cards) {
        [
          deck.cards.find_by(rank: "6", suit: "Hearts"),
          deck.cards.find_by(rank: "6", suit: "Diamonds")
        ]
      }
      let(:hands) {
        [Hands::Hand.new(cards:, player_id: player1.id)]
      }

      describe ".find_top_hands" do
        it "returns the top hands for each player" do
          top_hands = described_class.find_top_hands(hands, board)

          expect(top_hands[player1.id].level).to eq(Hands::ThreeOfAKind)
        end
      end
    end

    context "when the best hand is a straight" do
      let(:board) {
        [
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "3", suit: "Clubs"),
          deck.cards.find_by(rank: "4", suit: "Spades"),
          deck.cards.find_by(rank: "5", suit: "Clubs"),
          deck.cards.find_by(rank: "6", suit: "Clubs")
        ]
      }
      let(:cards) {
        [
          deck.cards.find_by(rank: "7", suit: "Hearts"),
          deck.cards.find_by(rank: "8", suit: "Diamonds")
        ]
      }
      let(:hands) { [Hands::Hand.new(cards:, player_id: player1.id)] }

      describe ".find_top_hands" do
        it "returns the top hands for each player" do
          top_hands = described_class.find_top_hands(hands, board)
          expect(top_hands[player1.id].level).to eq(Hands::Straight)
        end
      end
    end

    context "when the best hand is a flush" do
      let(:board) {
        [
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "4", suit: "Spades"),
          deck.cards.find_by(rank: "6", suit: "Spades"),
          deck.cards.find_by(rank: "8", suit: "Spades"),
          deck.cards.find_by(rank: "10", suit: "Spades")
        ]
      }
      let(:cards) {
        [
          deck.cards.find_by(rank: "6", suit: "Hearts"),
          deck.cards.find_by(rank: "8", suit: "Hearts")
        ]
      }
      let(:hands) {
        [Hands::Hand.new(cards:, player_id: player1.id)]
      }

      describe ".find_top_hands" do
        it "returns the top hands for each player" do
          top_hands = described_class.find_top_hands(hands, board)

          expect(top_hands[player1.id].level).to eq(Hands::Flush)
        end
      end
    end

    context "when the best hand is a full house" do
      let(:board) {
        [
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "2", suit: "Clubs"),
          deck.cards.find_by(rank: "6", suit: "Spades"),
          deck.cards.find_by(rank: "8", suit: "Clubs"),
          deck.cards.find_by(rank: "10", suit: "Clubs")
        ]
      }
      let(:cards) {
        [
          deck.cards.find_by(rank: "6", suit: "Hearts"),
          deck.cards.find_by(rank: "6", suit: "Diamonds")
        ]
      }
      let(:hands) { [Hands::Hand.new(cards:, player_id: player1.id)] }

      describe ".find_top_hands" do
        it "returns the top hands for each player" do
          top_hands = described_class.find_top_hands(hands, board)

          expect(top_hands[player1.id].level).to eq(Hands::FullHouse)
        end
      end
    end

    context "when the best hand is a four of a kind" do
      let(:board) {
        [
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "2", suit: "Clubs"),
          deck.cards.find_by(rank: "2", suit: "Hearts"),
          deck.cards.find_by(rank: "8", suit: "Clubs"),
          deck.cards.find_by(rank: "10", suit: "Clubs")
        ]
      }
      let(:cards) {
        [
          deck.cards.find_by(rank: "2", suit: "Hearts"),
          deck.cards.find_by(rank: "6", suit: "Diamonds")
        ]
      }
      let(:hands) { [Hands::Hand.new(cards:, player_id: player1.id)] }

      describe ".find_top_hands" do
        it "returns the top hands for each player" do
          top_hands = described_class.find_top_hands(hands, board)

          expect(top_hands[player1.id].level).to eq(Hands::FourOfAKind)
        end
      end
    end

    context "when the best hand is a straight flush" do
      let(:board) {
        [
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "3", suit: "Spades"),
          deck.cards.find_by(rank: "4", suit: "Spades"),
          deck.cards.find_by(rank: "5", suit: "Spades"),
          deck.cards.find_by(rank: "6", suit: "Spades")
        ]
      }
      let(:cards) {
        [
          deck.cards.find_by(rank: "10", suit: "Hearts"),
          deck.cards.find_by(rank: "9", suit: "Hearts")
        ]
      }
      let(:hands) {
        [
          Hands::Hand.new(cards:, player_id: player1.id)
        ]
      }

      describe ".find_top_hands" do
        it "returns the top hands for each player" do
          top_hands = described_class.find_top_hands(hands, board)

          expect(top_hands[player1.id].level).to eq(Hands::StraightFlush)
        end
      end
    end

    context "when there is a straight and a pair" do
      let(:board) {
        [
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "3", suit: "Clubs"),
          deck.cards.find_by(rank: "4", suit: "Spades"),
          deck.cards.find_by(rank: "5", suit: "Clubs"),
          deck.cards.find_by(rank: "6", suit: "Clubs")
        ]
      }
      let(:cards) {
        [
          deck.cards.find_by(rank: "7", suit: "Hearts"),
          deck.cards.find_by(rank: "2", suit: "Diamonds")
        ]
      }
      let(:hands) {
        [
          Hands::Hand.new(cards:, player_id: player1.id)
        ]
      }

      describe ".find_top_hands" do
        it "returns the top hands for each player" do
          top_hands = described_class.find_top_hands(hands, board)

          expect(top_hands[player1.id].level).to eq(Hands::Straight)
        end
      end
    end

    context "when there are multiple hands" do
      let(:cards) {
        [
          deck.cards.find_by(rank: "5", suit: "Hearts"),
          deck.cards.find_by(rank: "6", suit: "Diamonds")
        ]
      }

      let(:player2_cards) {
        [
          deck.cards.find_by(rank: "7", suit: "Hearts"),
          deck.cards.find_by(rank: "3", suit: "Diamonds")
        ]
      }
      let(:hands) {
        [
          Hands::Hand.new(cards: cards, player_id: player1.id),
          Hands::Hand.new(cards: player2_cards, player_id: player2.id)
        ]
      }

      it "returns the top hands for each player" do
        top_hands = described_class.find_top_hands(hands, board)

        expect(top_hands[player1.id].level).to eq(Hands::Straight)
        expect(top_hands[player2.id].level).to eq(Hands::TwoPairs)
      end
    end

    context "and there are multiple hands with the same level" do
      let(:cards) {
        [
          deck.cards.find_by(rank: "2", suit: "Hearts"),
          deck.cards.find_by(rank: "10", suit: "Diamonds")
        ]
      }
      let(:player2_cards) {
        [
          deck.cards.find_by(rank: "2", suit: "Clubs"),
          deck.cards.find_by(rank: "Ace", suit: "Spades")
        ]
      }
      let(:hands) {
        [
          Hands::Hand.new(cards:, player_id: player1.id),
          Hands::Hand.new(cards: player2_cards, player_id: player2.id)
        ]
      }

      describe ".find_top_hands" do
        it "returns the top hands for each player" do
          top_hands = described_class.find_top_hands(hands, board)

          expect(top_hands[player1.id].level).to eq(Hands::OnePair)
          expect(top_hands[player2.id].level).to eq(Hands::OnePair)
        end
      end
    end
  end

  describe ".find_winners" do
    let(:game) { create(:game) }
    let(:player1) { create(:player, game:) }
    let(:player2) { create(:player, game:) }

    let(:hands) {
      [
        winning_hand,
        losing_hand
      ]
    }

    context "when top hands are different" do
      let(:cards) {
        [
          deck.cards.find_by(rank: "7", suit: "Hearts"),
          deck.cards.find_by(rank: "8", suit: "Diamonds")
        ]
      }
      let(:player2_cards) {
        [
          deck.cards.find_by(rank: "2", suit: "Hearts"),
          deck.cards.find_by(rank: "10", suit: "Diamonds")
        ]
      }
      let(:board) {
        [
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "3", suit: "Clubs"),
          deck.cards.find_by(rank: "4", suit: "Spades"),
          deck.cards.find_by(rank: "7", suit: "Clubs"),
          deck.cards.find_by(rank: "9", suit: "Clubs")
        ]
      }
      let(:winning_hand) {
        Hands::Hand.new(cards: cards + board, player_id: player1.id)
      }
      let(:losing_hand) {
        Hands::Hand.new(cards: player2_cards + board, player_id: player2.id)
      }

      before do
        winning_hand.cards.each do |card|
          card.update!(cardable: player1)
        end

        losing_hand.cards.each do |card|
          card.update!(cardable: player2)
        end
      end

      let(:expected) {
        [
          deck.cards.find_by(rank: "2", suit: "Hearts"),
          deck.cards.find_by(rank: "10", suit: "Diamonds"),
          deck.cards.find_by(rank: "2", suit: "Spades"),
          deck.cards.find_by(rank: "7", suit: "Clubs"),
          deck.cards.find_by(rank: "9", suit: "Clubs")
        ]
      }

      it "returns the winners" do
        winning_player_ids = described_class.find_winners(hands, board)
        expect(winning_player_ids).to eq([player1.id])
      end
    end
  end
end
