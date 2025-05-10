class Player::Component < ViewComponent::Base
  attr_reader :player, :game

  def initialize(player)
    @player = player
    @game = player.game
  end

  def render?
    player.present?
  end

  def card_bg_color
    if player.folded?
      "bg-gray-200"
    elsif game.top_hands.include?(player)
      "bg-green-200"
    else
      ""
    end
  end

  def check_or_call(player)
    if player.owes_the_pot.positive?
      "Call"
    else
      "Check"
    end
  end
end
