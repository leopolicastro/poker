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
      # Compare the top five cards in order
      top_five = self.class.top_five(hand).sort_by(&:value).reverse
      other_top_five = self.class.top_five(other.hand).sort_by(&:value).reverse

      # Compare each card in order until we find a difference
      top_five.zip(other_top_five).each do |card1, card2|
        comparison = card1.value <=> card2.value
        return comparison unless comparison.zero?
      end

      0 # If all cards are equal, return 0
    end
  end
end
