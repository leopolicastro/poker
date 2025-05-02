module Cardable
  extend ActiveSupport::Concern

  included do
    has_many :cards, as: :cardable

    def first_card
      cards.first
    end

    def last_card
      cards.last
    end

    def cards_left
      cards.count
    end
  end
end
