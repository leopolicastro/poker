class Rounds::Showdown < Round
  def handle_round!
    game.current_turn.update!(turn: false)
    top_hands = game.top_hands
    if top_hands.count > 1
      # TODO: its kinda weird that the game is responsible for figuring out how to split the pot
      game.split_pot_payout!(winners: top_hands)
    else
      # But the payout method is on the player model
      game.top_hands.each(&:payout!)
    end

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
