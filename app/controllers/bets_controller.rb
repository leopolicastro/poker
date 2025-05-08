class BetsController < ApplicationController
  allow_unauthenticated_access
  def create
    @game = Game.find(params[:game_id])
    @player = @game.players.active.find(params[:player_id])

    amount = (params[:type] == "fold") ? 0 : @player.owes_the_pot
    @game.current_round.bets.create!(
      player: @player,
      amount: amount,
      type: infer_bet_type
    )
    if @game.current_round.concluded?
      @game.current_round.next_round!
    else
      @player.end_turn!
    end

    redirect_back(fallback_location: root_path)
  end

  def infer_bet_type
    if params[:type] == "fold"
      "Fold"
    elsif @game.current_round.type == "PreFlop" &&
        params[:type] != "raise" &&
        @game.current_round.bets.where(type: "Raise").empty? &&
        @player.bets.where(round: @game.current_round).sum(:amount) < @game.big_blind
      "Blind"
    else
      params[:type]
    end
  end
end
