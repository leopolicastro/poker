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
    players.active.all? do |player|
      round_bets = player.bets.where(round: self)
      round_bets.any? { |bet| ["AllIn"].include?(bet.type) } ||
        (round_bets.any? && round_bets.sum(:amount) >= player.owes_the_pot)
    end
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
