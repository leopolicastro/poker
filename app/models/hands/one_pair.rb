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

    # def detail_compare(other)
    #   # Get the top five cards for both hands
    #   my_top_five = self.class.top_five(hand)
    #   other_top_five = self.class.top_five(other.hand)
    #   # For one pair hands, we need to compare the pairs first, then the kickers
    #   # Get the pair values
    #   my_pair_value = my_top_five[0].value
    #   other_pair_value = other_top_five[0].value

    #   # Compare pair values first
    #   pair_comparison = my_pair_value <=> other_pair_value
    #   return pair_comparison unless pair_comparison.zero?

    #   # If pairs are equal, compare kickers
    #   my_kickers = my_top_five[2..4]
    #   other_kickers = other_top_five[2..4]

    #   my_kickers.zip(other_kickers).each do |my_card, other_card|
    #     comparison = my_card.value <=> other_card.value
    #     return comparison unless comparison.zero?
    #   end
    #   0
    # end
  end
end
