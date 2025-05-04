class Showdown < Round
  def handle_round!
    game.players.update_all(turn: false)
  end
end
