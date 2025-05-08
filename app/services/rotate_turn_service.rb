class RotateTurnService
  def self.call(game:)
    new(game:).call
  end

  def initialize(game:)
    @game = game
    @players = game.players.ordered
  end

  def call
    if @players.active.count <= 1
      return @game.hands.create!
    end
    # Get all active players in order
    players = @players.to_a

    # Find the current player with turn
    current_player = players.find { |p| p.turn? }

    # If no player has turn, start with the first player
    if current_player.nil?
      raise "No active players"
    end

    @players.update_all(turn: false)
    # Find the index of the current player
    current_index = players.index(current_player)

    # Calculate the next player's index (clockwise rotation)
    next_index = (current_index + 1) % players.size

    # Update turns
    player = players[next_index]
    until player.active?
      next_index = (next_index + 1) % players.size
      player = players[next_index]
    end
    player.update!(turn: true)
  end
end
