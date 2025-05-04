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
      hand.values_desc_by_occurency <=>
        other.cards.values_desc_by_occurency
    end
  end
end
