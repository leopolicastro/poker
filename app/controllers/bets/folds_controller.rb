class Bets::FoldsController < ApplicationController
  allow_unauthenticated_access

  def create
    @game = Game.find(params[:game_id])
    @player = @game.players.active.find(params[:player_id])

    unless @player.present?
      redirect_back(fallback_location: root_path, alert: "Player not found")
      return
    end

    @game.current_round.bets.create!(
      player_id: @player.id,
      amount: 0,
      type: "Bets::Fold"
    )

    redirect_back(fallback_location: root_path)
  end
end
