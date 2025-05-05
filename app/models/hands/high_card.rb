module Hands
  class HighCard < Base
    def self.satisfied?(hand)
      true
    end

    def self.top_five(hand)
      ace_high = hand.cards.sort_by(&:value).last(5).reverse
      [ace_high].max_by { |cards| cards.map(&:value) }
    end
  end
end
