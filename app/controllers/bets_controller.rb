class BetsController < ApplicationController
  allow_unauthenticated_access
  def create
    unless params[:type].present?
      redirect_back(fallback_location: root_path)
    end

    @game = Game.find(params[:game_id])
    @player = @game.players.active.find(params[:player_id])

    @game.current_round.bets.create!(
      player: @player,
      amount: amount,
      type: "Bets::#{params[:type]}"
    )

    redirect_back(fallback_location: root_path)
  end

  private

  def amount
    (params[:type] == "Fold") ? 0 : @player.owes_the_pot
  end
end
