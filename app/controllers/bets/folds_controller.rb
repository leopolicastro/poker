class Bets::FoldsController < ApplicationController
  allow_unauthenticated_access

  def create
    @game = Game.find(params[:game_id])
    @player = @game.players.active.find(params[:player_id])

    @game.current_round.bets.create!(
      player: @player,
      amount: 0,
      type: "Bets::Fold"
    )

    redirect_back(fallback_location: root_path)
  end
end
