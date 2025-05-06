module Hands
  class Base
    attr_reader :hand

    def initialize(hand)
      @hand = hand
    end

    # When you call max on an array of instances of a class, Ruby will use the <=> (spaceship)
    # operator to compare the objects. By default, the <=> operator returns nil unless the
    # class has a custom implementation for it.
    def <=>(other)
      unless other.instance_of?(self.class)
        fail "Can't detail compare hands of different level"
      end

      detail_compare(other)
    end

    def detail_compare(other)
      # Get the top five cards for both hands
      my_top_five = self.class.top_five(hand)
      other_top_five = self.class.top_five(other.hand)

      # For one pair hands, we need to compare the pairs first, then the kickers
      if self.class == Hands::OnePair
        # Get the pair values
        my_pair_value = my_top_five[0].value
        other_pair_value = other_top_five[0].value

        # Compare pair values first
        pair_comparison = my_pair_value <=> other_pair_value
        return pair_comparison unless pair_comparison.zero?

        # If pairs are equal, compare kickers
        my_kickers = my_top_five[2..4]
        other_kickers = other_top_five[2..4]

        my_kickers.zip(other_kickers).each do |my_card, other_card|
          comparison = my_card.value <=> other_card.value
          return comparison unless comparison.zero?
        end

        return 0
      end

      # For other hand types, compare cards in order
      my_top_five.zip(other_top_five).each do |my_card, other_card|
        comparison = my_card.value <=> other_card.value
        return comparison unless comparison.zero?
      end

      0 # If all cards are equal, return 0
    end
  end
end
