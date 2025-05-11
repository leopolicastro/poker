class PayoutWinnersService
  attr_reader :game
  def self.call(game:)
    new(game:).call
  end

  def initialize(game:)
    @game = game
    @players = game.players
  end

  def call
    top_hands = game.top_hands
    if @players.all_in.where(id: top_hands.map(&:id)).any?
      game.all_in_payout!(winners: top_hands)
    elsif top_hands.count > 1
      # TODO: it's kind of weird that split_pot_payout! is on the game model
      game.split_pot_payout!(winners: top_hands)
    else
      # But the payout method is on the player model
      top_hands.each(&:payout!)
    end
  end
end
