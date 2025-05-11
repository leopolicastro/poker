class Bets::RaisesController < ApplicationController
  allow_unauthenticated_access
  def create
    @game = Game.find(params[:game_id])
    @player = @game.players.active.find(params[:player_id])

    handle_raise

    redirect_back(fallback_location: root_path)
  end

  private

  def handle_raise
    if @player.owes_the_pot > 0
      @game.current_round.bets.create!(
        player: @player,
        amount: @player.owes_the_pot,
        type: "Bets::Call",
        rotate_turn: false
      )
    end

    # Then create the raise bet
    raise_amount = params[:amount].to_i - @player.owes_the_pot
    if raise_amount > 0
      @game.current_round.bets.create!(
        player: @player,
        amount: raise_amount,
        type: "Bets::Raise"
      )
    end
  end
end
