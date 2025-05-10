class Rounds::Showdown < Round
  def handle_round!
    PayoutWinnersService.call(game:)

    game.hands.last.bets.placed.update_all(state: :lost)

    StartNextHandJob.set(wait: 5.seconds).perform_later(game_id: game.id)
  end

  def pot
    hand.bets.sum(:amount)
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
