class FoldIfUnresponsiveJob < ApplicationJob
  queue_as :default

  def perform(round_id:, player_id:, current_bets_count: 0)
    round = Round.find(round_id)
    return if round.concluded?

    player = Player.find(player_id)
    return if round.bets.where(player:).count > current_bets_count

    player.bets.create!(round:, amount: 0, type: "Bets::Fold")
  end
end
