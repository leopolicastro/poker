module Hands
  class OnePair < Base
    def self.satisfied?(cards)
      cards.sorted_values
        .group_by(&:itself)
        .any? { |_, group| group.size == 2 }
    end

    def self.top_five(hand)
      grouped = hand.cards.sort_by { |card| [card.value, card.suit] }.group_by(&:value)
      grouped.select { |_, group| group.size == 2 }.values.flatten +
        hand.cards.reject { |card| grouped[card.value].size == 2 }.sort_by(&:value).last(3).reverse
    end
  end
end
