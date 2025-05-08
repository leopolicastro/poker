class Flop < Round
  def handle_round!
    players.active.update_all(turn: false)
    players.small_blind.first.update!(turn: true)
    game.draw(count: 1, burn_card: true)
    game.draw(count: 3)
  end

  def concluded?
    return false if bets.last&.type == "Raise"

    players.active.all? do |player|
      player.bets.where(round: self).any? && player.bets.where(round: self).sum(:amount) >= player.owes_the_pot
    end
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
