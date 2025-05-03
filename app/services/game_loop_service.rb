class GameLoopService
  attr_reader :game, :players
  def initialize(game)
    @game = game
    @players = game.players
  end
end
