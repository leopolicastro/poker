class Player::Component < ViewComponent::Base
  attr_reader :player, :game

  def initialize(player)
    @player = player
    @game = player.game
  end

  def render?
    player.present?
  end

  def last_round_bet
    player.bets.where(round: game.current_round).last
  end

  def card_bg_color
    if player.folded?
      "bg-gray-400"
    elsif game.top_hands.include?(player)
      "bg-green-200"
    else
      "bg-white"
    end
  end
end
