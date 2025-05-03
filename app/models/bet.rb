class Bet < ApplicationRecord
  belongs_to :player

  after_create_commit :balance_the_books

  after_update_commit :payout_winner!, if: -> { won? }

  include Chippable

  enum :state, {
    placed: 0,
    raised: 1,
    won: 2,
    lost: 3,
    resolved: 4
  }

  # aliias won! and lost!
  alias_method :win!, :won!
  alias_method :lose!, :lost!

  # TODO: bets need a bet type state, or enum, to differentiate between different types of bets

  def balance_the_books
    # consolidate the player's chips into one chip record
    player.consolidate_chips
    # get the amount of the bet in chips
    player.split_chips(amount:, chippable: player.game)
  end

  def payout_winner!
    # TODO: this method only works correctly when there is one winner
    chip = player.game.consolidate_chips
    # give them to the winner
    chip.update!(chippable: player)
    # consolidate the player's chips into one chip record
    player.consolidate_chips
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
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :integer          not null
#
# Indexes
#
#  index_bets_on_player_id  (player_id)
#
# Foreign Keys
#
#  player_id  (player_id => players.id)
#
