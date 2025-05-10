class Game::Board::Component < ViewComponent::Base
  attr_reader :game

  def initialize(game:)
    @game = game
  end

  def render?
    game.present?
  end
end
