class Hand < ApplicationRecord
  belongs_to :game
  has_many :rounds
  has_many :bets, through: :rounds

  delegate :players, to: :game

  after_create_commit :create_pre_flop!

  def create_pre_flop!
    PreFlop.create!(hand: self)
    players.update_all(state: "active")
    players.active.where.not(table_position: :button).ordered.first.update!(turn: true) unless game.hands.count == 1
  end
end

# == Schema Information
#
# Table name: hands
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer          not null
#
# Indexes
#
#  index_hands_on_game_id  (game_id)
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#
