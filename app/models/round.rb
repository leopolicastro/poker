class Round < ApplicationRecord
  belongs_to :game, touch: true
  belongs_to :current_turn, class_name: "Player"

  delegate :deck, :players, to: :game

  enum :phase, {pre_flop: 0, flop: 1, turn: 2, river: 3, showdown: 4, closed: 5}
  has_many :bets, dependent: :destroy

  after_create_commit :set_table

  def set_table
    deck.shuffle!
    game.current_turn.end_turn! if game.current_turn.present?
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id              :integer          not null, primary key
#  phase           :integer          default("pre_flop"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_turn_id :integer          not null
#  game_id         :integer          not null
#
# Indexes
#
#  index_rounds_on_current_turn_id  (current_turn_id)
#  index_rounds_on_game_id          (game_id)
#
# Foreign Keys
#
#  current_turn_id  (current_turn_id => players.id)
#  game_id          (game_id => games.id)
#
