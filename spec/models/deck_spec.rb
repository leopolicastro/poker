require "rails_helper"

RSpec.describe Deck, type: :model do
  let(:deck) { create(:deck) }

  before do
    deck.shuffle!
  end

  describe "factories" do
    it "has a valid factory" do
      expect(build(:deck)).to be_valid
    end
  end

  describe "cards_left" do
    it "returns the number of cards left in the deck" do
      expect(deck.cards_left).to eq(52)
    end

    it "returns the number of cards left in the deck after drawing cards" do
      deck.draw(count: 2)
      expect(deck.cards_left).to eq(50)
    end

    it "returns the number of cards left in the deck after drawing cards" do
      deck.draw(count: 2)
      deck.draw(count: 4)
      deck.draw(count: 6)
      expect(deck.cards_left).to eq(40)
    end
  end

  describe "draw" do
    it "returns the number of cards drawn" do
      expect(deck.draw(count: 2).count).to eq(2)
      expect(deck.cards_left).to eq(50)
    end

    it "assigns the cardable to the deck if no cardable is provided" do
      card = deck.draw(count: 1).first
      expect(card.cardable).to eq(deck)
    end

    it "assigns the cardable to the provided cardable" do
      player = create(:player)
      card = deck.draw(count: 1, cardable: player).first
      expect(card.cardable).to eq(player)
    end

    it "returns an array of cards" do
      expect(deck.draw(count: 2)).to be_an_instance_of(Array)
    end
  end

  describe "find_card" do
    it "returns the card with the given rank and suit" do
      card = deck.find_card("Ace", "Hearts")
      expect(card).to be_an_instance_of(Card)
      expect(card.rank).to eq("Ace")
      expect(card.suit).to eq("Hearts")
    end
  end

  describe "shuffle" do
    it "returns the deck" do
      expect(deck.shuffle!).to eq(deck)
    end

    it "shuffles the deck" do
      current_cards = deck.cards.pluck(:rank, :suit)
      deck.shuffle!
      new_cards = deck.cards.pluck(:rank, :suit)
      expect(new_cards).not_to eq(current_cards)
    end
  end
end

# == Schema Information
#
# Table name: decks
#
#  id            :integer          not null, primary key
#  deckable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deckable_id   :integer
#
# Indexes
#
#  index_decks_on_deckable  (deckable_type,deckable_id)
#
