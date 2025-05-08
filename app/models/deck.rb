class Deck < ApplicationRecord
  belongs_to :game, optional: true

  has_many :cards, -> { order(position: :asc) }, dependent: :destroy
  has_many :drawn, -> { order(updated_at: :desc) }, as: :cardable, dependent: :destroy, class_name: "Card"

  after_create :setup!

  def shuffle!
    card_ids = cards.pluck(:id)
    shuffled_positions = (1..card_ids.size).to_a.shuffle

    # Update each card's position in a single query per card
    card_ids.zip(shuffled_positions).each do |card_id, new_position|
      cards.where(id: card_id).update_all(
        position: new_position,
        cardable_id: nil,
        cardable_type: nil
      )
    end
  end

  def draw(count: 1, cardable: nil, burn_card: false)
    drawn_cards = cards.left.take(count)
    drawn_cards.map! do |card|
      card.update!(cardable: cardable || self, burn_card:)
      card
    end
  end

  def cards_left
    cards.left.count
  end

  def find_card(rank, suit)
    cards.find_by(rank:, suit:)
  end

  private

  def setup!
    cards_array = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank|
        cards_array << {
          deck_id: id,
          suit: suit,
          rank: rank,
          position: cards_array.length + 1
        }
      end
    end
    Card.insert_all(cards_array)
    shuffle!
  end
end

# == Schema Information
#
# Table name: decks
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer
#
# Indexes
#
#  index_decks_on_game_id  (game_id)
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#
