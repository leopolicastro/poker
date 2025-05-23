class Bet < ApplicationRecord
  belongs_to :player
  belongs_to :round

  validate :player_has_enough_chips

  delegate :game, to: :player

  before_validation :handle_bet_type!, on: :create
  after_create_commit :throw_into_pot!

  include Chippable
  include ActionView::Helpers::NumberHelper

  enum :state, {
    placed: 0,
    won: 1,
    lost: 2
  }

  BET_TYPES = %w[Bets::Check Bets::Call Bets::Raise Bets::Fold Bets::Blind Bets::AllIn].freeze
  BET_TYPES.each do |bet_type|
    scope bet_type.demodulize.underscore, -> { where(type: bet_type) }
  end

  def handle_bet_type!
    if player.broke?
      self.type = "Bets::AllIn"
    end
  end

  def throw_into_pot!
    # consolidate the players chips into one chip record
    player.consolidate_chips
    # place the bet in the pot
    player.split_chips(amount:, chippable: game)
    handle_bet! unless rotate_turn == false
  end

  def handle_bet!
    if game.players.where.not(state: :folded).count == 1
      game.current_hand.rounds.create!(type: "Rounds::Showdown")
    elsif game.current_round.concluded?
      game.current_round.next_round!
    else
      RotateTurnService.call(game:)
    end
  end

  private

  def player_has_enough_chips
    raise "Player does not have enough chips" if player.current_holdings < amount
  end
end

# == Schema Information
#
# Table name: bets
#
#  id          :integer          not null, primary key
#  amount      :integer          default(0), not null
#  answered    :boolean          default(FALSE), not null
#  rotate_turn :boolean          default(TRUE), not null
#  state       :integer          default("placed"), not null
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  player_id   :integer          not null
#  round_id    :integer          not null
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
