class Turn < Round
  def handle_round!
    game.players.update_all(turn: false)
    game.players.active.ordered.second.update!(turn: true)
    game.draw
  end
end
