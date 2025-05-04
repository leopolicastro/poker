class Round < ApplicationRecord
  belongs_to :game, touch: true
  has_many :bets, dependent: :destroy

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
    game.rounds.create!(type: next_type) if next_type
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
#  game_id    :integer          not null
#
# Indexes
#
#  index_rounds_on_game_id  (game_id)
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#
