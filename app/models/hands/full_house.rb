module Hands
  class FullHouse < Base
    def self.satisfied?(hand)
      values = hand.cards.group_by(&:value).values
      values.one? { |group| group.size == 3 } && values.one? { |group| group.size == 2 }
    end

    def self.top_five(hand)
      values = hand.cards.sort_by { |card| [card.value, card.suit] }.group_by(&:value)

      three_of_a_kind = values.values.find { |group| group.size == 3 }
      pair = values.values.select { |group| group.size == 2 }.max_by { |group| group.first.value }
      three_of_a_kind + pair
    end
  end
end
