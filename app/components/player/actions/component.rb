class Player::Actions::Component < ViewComponent::Base
  attr_reader :player, :game

  def initialize(player:)
    @player = player
    @game = player.game
  end

  def render?
    player.present? && player.active?
  end

  def check_or_call(player)
    if player.owes_the_pot.positive?
      "Call"
    else
      "Check"
    end
  end

  def check_or_call_with_amount(player)
    if player.owes_the_pot.positive?
      "Call #{number_to_currency(player.owes_the_pot)}"
    else
      "Check"
    end
  end

  def starting_raise_amount(player)
    current_round = game.current_round
    # Get all raises in the current round
    raises = current_round.bets.where(type: "Bets::Raise")

    if raises.any? && current_round.type == "Rounds::PreFlop"
      (raises.last.amount * 2) + player.game.big_blind
    elsif raises.any?
      [raises.last.amount, player.game.big_blind].max * 2
    else
      player.game.big_blind * 2
    end
  end

  def raise_step_amount(game)
    raises = game.current_round.bets.where(type: "Bets::Raise")
    if raises.any?
      raises.last.amount
    else
      game.big_blind
    end
  end
end
