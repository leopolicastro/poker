class RotateTablePositionsService
  def self.call(game:)
    new(game:).call
  end

  def initialize(game:)
    @game = game
    @players = game.players.ordered
  end

  def call
    @players.update_all(turn: false)
    players = @players.to_a

    # Store current positions
    current_positions = players.map { |p| p.table_position }

    # Set all to field first
    players.each { |p| p.update!(table_position: :field) }

    # Assign each player the position of the player to their right
    players.each_with_index do |player, index|
      right_player_index = (index + 1) % players.size
      player.update!(table_position: current_positions[right_player_index])
    end
  end
end
