module Bets
  extend ActiveSupport::Concern

  included do
    has_many :bets, dependent: :destroy

    accepts_nested_attributes_for :bets, allow_destroy: true

    def place_bet!(amount:, bet_type:)
      return unless current_holdings >= amount

      bets.create!(amount:, round: game.hands.last.rounds.last, bet_type:)
    end
  end
end
