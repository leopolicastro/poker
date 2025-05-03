class Deck < ApplicationRecord
  belongs_to :deckable, polymorphic: true, optional: true
  has_many :cards, dependent: :destroy

  has_many :drawn, -> { order(position: :asc) }, as: :cardable, dependent: :destroy, class_name: "Card"

  after_create :shuffle!

  def shuffle!
    cards.delete_all if cards.any?
    cards_array = []

    Card::SUITS.each_with_index do |suit, index|
      Card::RANKS.each_with_index do |rank, rank_index|
        card = {
          deck_id: id,
          suit:,
          rank:,
          position: cards_array.length + 1
        }
        cards_array << card
      end
    end
    cards_array.shuffle!
    Card.insert_all(cards_array)

    reload
  end

  def draw(count: 1, cardable: nil)
    drawn_cards = cards.left.take(count)
    drawn_cards.map! do |card|
      cardable = cardable.present? ? cardable : self
      card.update(cardable:)
      card
    end
    drawn_cards
  end

  def cards_left
    cards.left.count
  end

  def find_card(rank, suit)
    cards.find_by(rank:, suit:)
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
