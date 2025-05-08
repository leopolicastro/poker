class Card < ApplicationRecord
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  ACE_LOW_RANKS = %w[A 2 3 4 5 6 7 8 9 10 J Q K].freeze
  SUITS = %w[Spade Heart Diamond Club].freeze

  belongs_to :deck, touch: true
  belongs_to :cardable, polymorphic: true, optional: true

  validates :rank, presence: true, uniqueness: {scope: %i[deck_id suit]}
  validates :suit, presence: true, inclusion: {in: SUITS}
  validates :position, uniqueness: {scope: :deck_id}

  scope :left, -> { where(cardable: nil) }
  scope :drawn, -> { where.not(cardable: nil) }
  scope :shuffled, -> { order(position: :asc) }
  scope :updated_at_desc, -> { order(updated_at: :desc) }
  scope :not_burned, -> { where(burn_card: false) }
  scope :burned, -> { where(burn_card: true) }
  scope :updated_at_asc, -> { order(updated_at: :asc) }

  acts_as_list scope: :deck

  include Presenter

  def value
    RANKS.index(rank) + 2
  end

  def ace_low_value
    ACE_LOW_RANKS.index(rank) + 1
  end
end

# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  burn_card     :boolean          default(FALSE), not null
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
