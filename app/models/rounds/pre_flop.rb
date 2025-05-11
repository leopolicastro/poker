class Rounds::PreFlop < Round
  def handle_round!
    deck.shuffle!
    game.in_progress!

    game.players.ordered.each do |player|
      game.deck.draw(count: 2, cardable: player)
    end
    if game.first_hand?
      game.assign_starting_positions!
    else
      RotateTablePositionsService.call(game:)
    end
    game.players.update_all(turn: false)
    first_to_act.update!(turn: true)
  end

  def concluded?
    blind_options_satisfied? && super
  end

  def blind_options_satisfied?
    big_blind_bets = game.players.big_blind.first.bets.where(round: self)
    small_blind_bets = game.players.small_blind.first.bets.where(round: self)
    big_blind_bets.count > 1 && small_blind_bets.count > 1
  end

  def first_to_act
    game.players.big_blind.first.to_the_right
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
