class BetsController < ApplicationController
  allow_unauthenticated_access
  def create
    @game = Game.find(params[:game_id])
    @player = @game.players.active.find(params[:player_id])

    amount = (params[:bet_type] == "fold") ? 0 : @game.big_blind - @player.bets.where(round: @game.current_round).sum(:amount)

    @game.current_round.bets.create(
      player: @player,
      amount: amount,
      bet_type: params[:bet_type]
    )
    if @game.current_round.concluded?
      @game.current_round.next_round!
    else
      @player.end_turn!
    end

    redirect_back(fallback_location: root_path)
  end
end
