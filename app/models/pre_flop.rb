class PreFlop < Round
  def handle_round!
    deck.shuffle!
    current_turn.end_turn! if current_turn.present?
    game.in_progress!

    game.players.ordered.each do |player|
      game.deck.draw(count: 2, cardable: player)
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
