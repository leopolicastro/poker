class Round < ApplicationRecord
  belongs_to :hand
  has_many :bets, dependent: :destroy

  delegate :game, to: :hand

  delegate :deck, :players, :current_turn, to: :game

  ROUND_TYPES = %w[Rounds::PreFlop Rounds::Flop Rounds::Turn Rounds::River Rounds::Showdown].freeze

  ROUND_TYPES.each do |round_type|
    scope round_type.demodulize.underscore, -> { where(type: round_type) }
  end

  after_create_commit :handle_round!

  def concluded?
    players.active.all? do |player|
      round_bets = player.bets.where(round: self)
      round_bets.any? { |bet| ["Bets::AllIn"].include?(bet.type) } ||
        (round_bets.any? && round_bets.sum(:amount) >= player.owes_the_pot)
    end
  end

  def next_round!
    current_type_index = ROUND_TYPES.index(type)
    next_type = ROUND_TYPES[current_type_index + 1]
    if game.hands.last.rounds.last.type == "Rounds::Showdown"
      game.hands.create!
    elsif next_type
      game.hands.last.rounds.create!(type: next_type)
    end
  end

  def first_to_act
    # Start from the position after small blind
    small_blind_position = players.small_blind.first.position

    # Find the first active player to the right of small blind
    # Using a single query instead of a loop
    players.active.ordered
      .where("position >= ?", small_blind_position)
      .first || players.active.ordered.first

    # Return nil if no active players found
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
