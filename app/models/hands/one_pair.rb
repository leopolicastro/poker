module Hands
  class OnePair < Base
    def self.satisfied?(cards)
      cards.sorted_values
        .group_by(&:itself)
        .any? { |_, group| group.size == 2 }
    end

    def self.top_five(hand)
      grouped = hand.cards.sort_by { |card| [card.value, card.suit] }.group_by(&:value)
      pairs = grouped.select { |_, group| group.size == 2 }
      # Get the highest pair
      highest_pair = pairs.max_by { |value, _| value }
      # Get the kickers (non-pair cards) sorted by value
      kickers = hand.cards.reject { |card| grouped[card.value].size == 2 }
        .sort_by(&:value)
        .last(3)
        .reverse

      # Return the pair cards first, then the kickers
      highest_pair[1] + kickers
    end
  end
end
