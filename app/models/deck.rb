class Deck < ApplicationRecord
  belongs_to :deckable, polymorphic: true, optional: true
  has_many :cards, dependent: :destroy

  has_many :drawn, -> { order(position: :asc) }, as: :cardable, dependent: :destroy, class_name: "Card"

  after_create :setup

  state_machine :state, initial: :initial do
    event :shuffle do
      transition any => :initial
    end

    event :draw_cards do
      transition any - [:drawn] => :drawn
    end

    event :discard do
      transition any => :discarded
    end

    after_transition on: :shuffle, do: :setup
  end

  def setup
    return shuffle unless initial?

    cards.delete_all
    cards = []

    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        card = {
          deck_id: id,
          suit:,
          rank:
        }
        cards << card
      end
    end
    cards.shuffle!
    cards.each_with_index do |card, index|
      card[:position] = index + 1
    end
    Card.insert_all(cards)

    reload
  end

  def draw(count: 1, cardable: nil)
    draw_cards unless drawn?

    cards.left.take(count).map do |card|
      cardable = cardable.present? ? cardable : self
      card.update(cardable:)
      card
    end
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
#  state         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deckable_id   :integer
#
# Indexes
#
#  index_decks_on_deckable  (deckable_type,deckable_id)
#
