class Rounds::Flop < Round
  def handle_round!
    players.active.update_all(turn: false)
    first_to_act.update!(turn: true)

    game.draw(count: 1, burn_card: true)
    game.draw(count: 3)
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
