class Round < ApplicationRecord
  belongs_to :hand
  has_many :bets, dependent: :destroy

  delegate :game, to: :hand

  delegate :deck, :players, :current_turn, to: :game

  ROUND_TYPES = %w[PreFlop Flop Turn River Showdown].freeze

  ROUND_TYPES.each do |type|
    scope type, -> { where(type:) }
  end

  after_create_commit :handle_round!

  def concluded?
    # TODO: this should be game.big_blind || game.current_bet ish
    # TODO: this is wrong, this only works if no one has bet yet
    players.active.all? { |player| player.bets.where(round: self).sum(:amount) >= game.big_blind }
  end

  def next_round!
    current_type_index = ROUND_TYPES.index(type)
    next_type = ROUND_TYPES[current_type_index + 1]
    if game.hands.last.rounds.last.type == "Showdown"
      game.hands.create!
    elsif next_type
      game.hands.last.rounds.create!(type: next_type)
    end
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  hand_id    :integer          not null
#
# Indexes
#
#  index_rounds_on_hand_id  (hand_id)
#
# Foreign Keys
#
#  hand_id  (hand_id => hands.id)
#
