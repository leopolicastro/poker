class Player::Component < ViewComponent::Base
  attr_reader :player, :game

  def initialize(player)
    @player = player
    @game = player.game
  end

  def render?
    player.present?
  end

    def check_or_call(player)
    if player.owes_the_pot.positive?
      "Call"
    else
      "Check"
    end
  end
end
