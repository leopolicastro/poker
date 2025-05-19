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
      amount: @player.owes_the_pot,
      type: handle_bet_type!
    )

    redirect_back(fallback_location: root_path)
  end

  private

  def handle_bet_type!
    if @player.current_holdings <= @player.owes_the_pot
      "Bets::AllIn"
    else
      "Bets::#{params[:type]}"
    end
  end
end
