class RotateTablePositionsService
  def self.call(game:)
    new(game:).call
  end

  def initialize(game:)
    @game = game
    @players = game.players.ordered
  end

  def call
    case @players.count
    when 2
      # In 2-player games: Button -> Big Blind, Big Blind -> Button
      @players.where(table_position: :button).update_all(table_position: :big_blind)
      @players.where(table_position: :big_blind).update_all(table_position: :small_blind)
    when 3
      # In 3-player games: Button -> Small Blind -> Big Blind -> Button
      @players.where(table_position: :button).update_all(table_position: :small_blind)
      @players.where(table_position: :small_blind).update_all(table_position: :big_blind)
      @players.where(table_position: :big_blind).update_all(table_position: :button)
    else
      # Get the players in order
      players = @players.to_a

      # Find the indices of the current positions
      button_idx = players.index { |p| p.table_position == "button" }
      small_blind_idx = players.index { |p| p.table_position == "small_blind" }
      big_blind_idx = players.index { |p| p.table_position == "big_blind" }

      # Find the next field player after the button (circular)
      next_button_idx = nil
      players.size.times do |offset|
        idx = (button_idx + 1 + offset) % players.size
        if players[idx].table_position == "field"
          next_button_idx = idx
          break
        end
      end

      # Set all to field first
      players.each { |p| p.update!(table_position: :field) }

      # Assign new positions
      players[button_idx].update!(table_position: :small_blind)
      players[small_blind_idx].update!(table_position: :big_blind)
      players[big_blind_idx].update!(table_position: :field)
      players[next_button_idx].update!(table_position: :button)
    end
  end
end
