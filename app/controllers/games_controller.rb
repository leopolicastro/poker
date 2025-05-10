class GamesController < ApplicationController
  allow_unauthenticated_access
  def show
    @demo_game = Game.find_by(name: "Demo Game")
    @demo_players = @demo_game.players
  end
end
