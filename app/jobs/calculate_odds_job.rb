class CalculateOddsJob < ApplicationJob
  queue_as :default

  def perform(round)
    round.calculate_odds
  end
end
