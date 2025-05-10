class RotateTurnService
  def self.call(game:)
    new(game:).call
  end

  def initialize(game:)
    @game = game
    @players = game.players.ordered
  end

  def call
    return if @game.current_round.concluded?

    if @players.active.count <= 1
      return @game.hands.create!
    end
    # Get all active players in order
    players = @game.reload.players.to_a

    # Find the current player with turn
    current_player = players.find { |p| p.turn? }

    # If no player has turn, start with the first player
    if current_player.nil?
      raise "No players with turn found"
    end

    @players.update_all(turn: false)
    # Find the index of the current player
    current_index = players.index(current_player)

    # Calculate the next player's index (clockwise rotation)
    next_index = (current_index + 1) % players.size

    # Update turns
    player = players[next_index]
    count = 0
    until player.active?
      next_index = (next_index + 1) % players.size
      player = players[next_index]
      count += 1
      raise "Infinite loop" if count > 10
    end
    player.update!(turn: true)
    # FoldIfUnresponsiveJob.set(wait: Round::PLAYER_TIMEOUT_WAIT).perform_later(
    #   round_id: @game.current_round.id,
    #   player_id: player.id,
    #   current_bets_count: @game.current_round.bets.where(player:).count
    # )
  end
end
