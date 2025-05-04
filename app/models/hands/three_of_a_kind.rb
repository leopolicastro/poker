module Hands
  class ThreeOfAKind < Base
    def self.satisfied?(cards)
      cards.sorted_values
        .group_by(&:itself)
        .any? { |_, group| group.size == 3 }
    end

    def self.top_five(hand)
      grouped = hand.cards.sort_by { |card| [card.value, card.suit] }.group_by(&:value)
      three_of_a_kind = grouped.select { |_, group| group.size == 3 }.values.flatten
      singles = hand.cards.reject { |card| grouped[card.value].size == 3 }
      three_of_a_kind + singles.sort_by(&:value).last(2).reverse
    end
  end
end
