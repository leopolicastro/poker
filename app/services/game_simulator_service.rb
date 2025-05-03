class GameSimulatorService
  attr_reader :game

  def self.run(game: nil)
    new(game:).run
  end

  def initialize(game: nil)
    @game = game
  end

  def run
    setup_game
  end

  private

  def setup_game
    return unless game.pending?

    generate_players
  end

  def generate_players
    [1, 2, 3, 4, 5].each do |i|
      game.players.create!(user: User.find_or_create_by(email: "demo-player#{i}@example.com"))
    end
  end
end
