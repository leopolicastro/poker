class Bet < ApplicationRecord
  belongs_to :player
  belongs_to :round

  delegate :game, to: :player

  after_create_commit :throw_into_pot!
  after_update_commit :payout_winner!, if: -> { state_previously_changed? && won? }

  include Chippable

  enum :state, {
    placed: 0,
    won: 1,
    lost: 2
  }

  enum :bet_type, {
    check: 0,
    call: 1,
    raise: 2,
    fold: 3,
    blinds: 4
  }

  def throw_into_pot!
    # consolidate the players chips into one chip record
    player.consolidate_chips
    # place the bet in the post
    player.split_chips(amount:, chippable: player.game)

    if fold?
      player.folded!
    end
  end

  def payout_winner!
    # TODO: this method only works correctly when there is one winner
    chip = player.game.consolidate_chips
    # give them to the winner
    chip.update!(chippable: player)
    # consolidate the player's chips into one chip record
    player.consolidate_chips
    won!
  end
end

# == Schema Information
#
# Table name: bets
#
#  id         :integer          not null, primary key
#  amount     :integer          default(0), not null
#  answered   :boolean          default(FALSE), not null
#  bet_type   :integer          default("check"), not null
#  state      :integer          default("placed"), not null
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
