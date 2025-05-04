class BetsController < ApplicationController
  allow_unauthenticated_access
  def create
    @game = Game.find(params[:game_id])
    @player = @game.players.find(params[:player_id])

    @game.current_round.bets.create(player: @player, amount: @game.big_blind)
    if @game.current_round.concluded?
      @game.current_round.next_round!
    else
      @player.end_turn!
    end

    redirect_back(fallback_location: root_path)
  end
end
