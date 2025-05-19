class RoundCompletePolicy
  attr_reader :round

  def initialize(round)
    @round = round
  end

  delegate :bets, :players, to: :round

  def satisfied?
    this_rounds_bets = bets.where.not(type: %w[Bets::Blind])
    return false if this_rounds_bets.empty?

    # Get all raises in this round
    raises = this_rounds_bets.where(type: %w[Bets::Raise])

    # If there are raises, we need to ensure all players have acted after the last raise
    if raises.any?
      last_raise = raises.last
      # Check if all players after the last raiser have acted
      players_after_raise = players.active.where("position > ?", last_raise.player.position)
      return false if players_after_raise.any? { |p| p.bets.where(round: round).empty? }

      # Also check if all players before the last raiser have acted after the raise
      players_before_raise = players.active.where("position < ?", last_raise.player.position)
      return false if players_before_raise.any? { |p| p.bets.where(round: round).where("created_at > ?", last_raise.created_at).empty? }
    end

    # Finally check if all active players have either gone all-in or matched the highest bet
    players.active.all? do |player|
      round_bets = this_rounds_bets.where(player:)
      return false if round_bets.empty?

      all_ins = round_bets.where(player: player, type: "Bets::AllIn")
      all_ins.any? || round_bets.sum(:amount) >= player.owes_the_pot
    end
  end
end
