class Round < ApplicationRecord
  belongs_to :hand
  has_many :bets, dependent: :destroy

  PLAYER_TIMEOUT_WAIT = Rails.env.local? ? 5.seconds : 30.seconds

  delegate :game, to: :hand
  delegate :deck, :players, :current_turn, to: :game

  ROUND_TYPES = %w[Rounds::PreFlop Rounds::Flop Rounds::Turn Rounds::River Rounds::Showdown].freeze

  ROUND_TYPES.each do |round_type|
    scope round_type.demodulize.underscore, -> { where(type: round_type) }
  end

  after_create_commit -> { handle_round! && CalculateOddsJob.perform_later(self) }

  def handle_round!
    players.update_all(turn: false)
    first_to_act.update!(turn: true)
  end

  def calculate_odds
    update!(odds: HandOddsService.call(game:))
    game.touch
  end

  def concluded?
    RoundCompletePolicy.new(self).satisfied?
  end

  def next_round!
    current_type_index = ROUND_TYPES.index(type)
    next_type = ROUND_TYPES[current_type_index + 1]
    if game.current_round.type == "Rounds::Showdown"
      game.hands.create!
    elsif next_type
      next_type.constantize.create!(hand: game.current_hand)
    end
  end

  def first_to_act
    current = players.small_blind.first
    players.count.times do
      return current if ["folded", "all_in"].exclude?(current.state)
      current = current.to_the_right
    end
    raise "No active players found"
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  odds       :json             not null
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
