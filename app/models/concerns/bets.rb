module Bets
  extend ActiveSupport::Concern

  included do
    has_many :bets, dependent: :destroy

    accepts_nested_attributes_for :bets, allow_destroy: true

    def place_bet(amount)
      return unless current_holdings >= amount

      bets.create!(amount:)
    end

    def current_bet
      bets.last
    end

    def current_bet_amount
      current_bet&.amount || 0
    end
  end
end
