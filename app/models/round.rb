class Round < ApplicationRecord
  belongs_to :hand
  has_many :bets, dependent: :destroy

  PLAYER_TIMEOUT_WAIT = Rails.env.local? ? 10.seconds : 30.seconds

  delegate :game, to: :hand

  delegate :deck, :players, :current_turn, to: :game

  ROUND_TYPES = %w[Rounds::PreFlop Rounds::Flop Rounds::Turn Rounds::River Rounds::Showdown].freeze

  ROUND_TYPES.each do |round_type|
    scope round_type.demodulize.underscore, -> { where(type: round_type) }
  end

  after_create_commit :handle_round!

  def handle_round!
  end

  def concluded?
    players.active.all? do |player|
      round_bets = player.bets.where(round: self)
      round_bets.any? { |bet| ["Bets::AllIn", "Bets::Fold"].include?(bet.type) } ||
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
    count = 0
    first = players.small_blind.first
    until first.active?
      first = first.to_the_right
      count += 1
      raise "Infinite loop" if count > players.count
    end
    first
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
