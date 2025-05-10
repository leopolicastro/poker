module Hands
  class TwoPairs < Base
    def self.satisfied?(hand)
      hand.sorted_values
        .group_by(&:itself)
        .count { |_, group| group.size == 2 }
        .>= 2
    end

    def self.top_five(hand)
      grouped = hand.cards.sort_by { |card| [card.value, card.suit] }.group_by(&:value)
      pairs = grouped.select { |_, group| group.size == 2 }
        .sort_by { |value, _| -value }
        .take(2)
        .map { |_, group| group }
        .flatten
      singles = hand.cards.reject { |card| grouped[card.value].size == 2 }
      pairs + singles.sort_by(&:value).last(1)
    end
  end
end
