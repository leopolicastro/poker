class GameSimulatorService
  attr_reader :game

  def self.run(players_count: 5, small_blind: 10, big_blind: 20)
    new(players_count:, small_blind:, big_blind:).run
  end

  def initialize(players_count:, small_blind:, big_blind:)
    @game = Game.find_or_create_by!(name: "Demo Game")
    @game.update!(small_blind:, big_blind:)
    @players_count = players_count
  end

  def run
    setup_preflop!
    game
  end

  private

  def setup_preflop!
    generate_players unless game.players.any?
    game.hands.create!
  end

  def generate_players
    (1..@players_count).each do |i|
      user = User.find_or_create_by!(email_address: "demo-player#{i}@example.com") do |user|
        user.password = "password"
      end
      user.bot_settings.update!(active: true)
      player = game.players.find_or_create_by!(user:)
      player.active!
      # instance_variable_set("@player#{i}", player)
      user.chips.create! value: 10000
      player.buy_in(1000)
    end
  end
end
