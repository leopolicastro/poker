class GameSimulatorService
  attr_reader :game

  def self.run
    new.run
  end

  def initialize
    @game = Game.find_or_create_by!(name: "Demo Game")
    @game.update(small_blind: 10, big_blind: 20)
  end

  def run
    setup_game
  end

  private

  def setup_game
    return unless game.pending?

    generate_players unless game.players.any?

    game.hands.first_or_create!
    game.assign_starting_positions_and_turn!
    game.in_progress! unless game.in_progress?
    game.players.active.ordered.each do |player|
      game.deck.draw(count: 2, cardable: player)
    end
  end

  def generate_players
    [1, 2, 3, 4, 5].each do |i|
      user = User.find_or_create_by!(email_address: "demo-player#{i}@example.com") do |user|
        user.password = "password"
      end
      player = game.players.find_or_create_by!(user:)
      instance_variable_set("@player#{i}", player)
      user.chips.create! value: 10000
      player.buy_in(1000)
    end
  end
end
