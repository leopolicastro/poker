module Hands
  class FourOfAKind < Base
    def self.satisfied?(hand)
      values = hand.cards.group_by(&:value).values
      values.one? { |group| group.size == 4 }
    end

    def self.top_five(hand)
      values = hand.cards.sort_by { |card| [card.value, card.suit] }.group_by(&:value).values
      cards_not_in_group = []
      values.each do |group|
        if group.size == 4
          cards_not_in_group = hand.cards - group
          group << cards_not_in_group.max_by(&:value)
          return group.sort_by(&:value)
        end
      end
    end
  end
end
