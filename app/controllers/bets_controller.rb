class BetsController < ApplicationController
  allow_unauthenticated_access
  def create
    @game = Game.find(params[:game_id])
    @player = @game.players.active.find(params[:player_id])

    amount = (params[:bet_type] == "fold") ? 0 : @player.owes_the_pot
    @game.current_round.bets.create!(
      player: @player,
      amount: amount,
      bet_type: infer_bet_type
    )
    if @game.current_round.concluded?
      @game.current_round.next_round!
    else
      @player.end_turn!
    end

    redirect_back(fallback_location: root_path)
  end

  def infer_bet_type
    if params[:bet_type] == "fold"
      "fold"
    elsif @game.current_round.type == "PreFlop" &&
        params[:bet_type] != "raise" &&
        @game.current_round.bets.where(bet_type: :raise).empty? &&
        @player.bets.where(round: @game.current_round).sum(:amount) < @game.big_blind
      "blinds"
    else
      params[:bet_type]
    end
  end
end
