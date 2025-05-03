class Card < ApplicationRecord
  belongs_to :deck
  belongs_to :cardable, polymorphic: true, optional: true

  acts_as_list scope: :deck

  validates :rank, presence: true, uniqueness: {scope: %i[deck_id suit]}
  validates :suit, presence: true
  validates :position, uniqueness: {scope: :deck_id}

  scope :ordered, -> { order(position: :asc) }

  include Images

  scope :left, -> { where(cardable: nil) }
  scope :drawn, -> { where.not(cardable: nil) }

  RANKS = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace].freeze
  ACE_LOW_RANKS = %w[Ace 2 3 4 5 6 7 8 9 10 Jack Queen King].freeze
  SUITS = %w[Spades Hearts Diamonds Clubs].freeze

  def to_s
    "#{rank}#{suit_icon}"
  end

  def suit_icon
    case suit
    when "Spades" then "♠"
    when "Hearts" then "♥"
    when "Diamonds" then "♦"
    when "Clubs" then "♣"
    end
  end

  def value
    RANKS.index(rank) + 2
  end

  def ace_low_value
    ACE_LOW_RANKS.index(rank) + 1
  end

  def image
    "https://lbpdev.us-mia-1.linodeobjects.com/active_deck/cards/#{rank_key}#{suit_key}.png"
  end

  def self.image_mapper
    {
      suit: {
        Hearts: "H",
        Spades: "S",
        Diamonds: "D",
        Clubs: "C"
      },
      rank: {
        Ace: "A",
        King: "K",
        Queen: "Q",
        Jack: "J",
        "10": "0",
        "9": "9",
        "8": "8",
        "7": "7",
        "6": "6",
        "5": "5",
        "4": "4",
        "3": "3",
        "2": "2"
      }
    }
  end

  private

  def suit_key(suit = self.suit)
    Card.image_mapper[:suit][suit.to_sym]
  end

  def rank_key(rank = self.rank)
    Card.image_mapper[:rank][rank.to_sym]
  end
end

# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  cardable_type :string
#  position      :integer
#  rank          :string
#  suit          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  cardable_id   :integer
#  deck_id       :integer          not null
#
# Indexes
#
#  index_cards_on_cardable  (cardable_type,cardable_id)
#  index_cards_on_deck_id   (deck_id)
#
# Foreign Keys
#
#  deck_id  (deck_id => decks.id)
#
