class Bet < ApplicationRecord
  belongs_to :player
  belongs_to :round

  delegate :game, to: :player

  after_create_commit :throw_into_pot!

  include Chippable

  enum :state, {
    placed: 0,
    won: 1,
    lost: 2
  }

  BET_TYPES = %w[Check Call Raise Fold Blind AllIn].freeze

  BET_TYPES.each do |type|
    scope type, -> { where(type:) }
  end

  def throw_into_pot!
    # consolidate the players chips into one chip record
    player.consolidate_chips
    # place the bet in the post
    player.split_chips(amount:, chippable: player.game)
  end
end

# == Schema Information
#
# Table name: bets
#
#  id         :integer          not null, primary key
#  amount     :integer          default(0), not null
#  answered   :boolean          default(FALSE), not null
#  state      :integer          default("placed"), not null
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :integer          not null
#  round_id   :integer          not null
#
# Indexes
#
#  index_bets_on_player_id  (player_id)
#  index_bets_on_round_id   (round_id)
#
# Foreign Keys
#
#  player_id  (player_id => players.id)
#  round_id   (round_id => rounds.id)
#
