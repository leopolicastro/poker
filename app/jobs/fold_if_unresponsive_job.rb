class FoldIfUnresponsiveJob < ApplicationJob
  queue_as :default

  def perform(round:, player:, current_bets_count:)
    round = round.reload
    return if round.concluded?

    return if round.bets.where(player:).count > current_bets_count

    player.bets.create!(round:, amount: 0, type: "Bets::Fold")
  end
end
