class Game::Component < ViewComponent::Base
  attr_reader :game

  def initialize(game:)
    @game = game
  end

  def render?
    game.present?
  end

  def check_or_call(player)
    if player.owes_the_pot.positive?
      "Call"
    else
      "Check"
    end
  end
end
