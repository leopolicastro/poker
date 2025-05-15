# Monte Carlo simulation to calculate the odds of each player winning the hand
class HandOddsService
  SIMULATIONS = 2_000

  def self.call(game:)
    new(game:).call
  end

  def initialize(game:)
    @game = game
    @active_players = game.players.active
    @community_cards = game.cards.community
    @deck = game.deck
  end

  def call
    return {} if @active_players.count <= 1

    return if @community_cards.size == 5

    calculate_monte_carlo_odds
  end

  private

  def calculate_monte_carlo_odds
    results = Hash.new(0)
    SIMULATIONS.times do
      # Get all cards that haven't been dealt yet
      temp_deck = @deck.cards.left.to_a

      # Simulate the remaining community cards
      remaining_cards = 5 - @community_cards.size
      shuffled_temp_deck = temp_deck.shuffle
      simulated_board = @community_cards + shuffled_temp_deck.sample(remaining_cards)

      # Create hand objects for each player
      player_hands = @active_players.map do |player|
        Hands::Hand.new(
          cards: player.cards,
          player_id: player.id
        )
      end

      # Find winners using the existing evaluator
      winners = Hands::Evaluator.find_winners(player_hands, simulated_board)

      # Award points to winners
      winners.each do |player_id|
        results[player_id] += 1.0 / winners.size
      end
    end

    # Ensure all active players have an entry in results
    @active_players.each do |player|
      results[player.id] ||= 0.0
    end

    # Convert to percentages
    results.transform_values { |wins| (wins / SIMULATIONS * 100).round(1) }
  end
end
