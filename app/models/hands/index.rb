module Hands
  class Index
    attr_reader :hand

    def initialize(hand)
      @hand = hand
    end

    RANKED_HANDS = [Hands::HighCard, Hands::OnePair,
      Hands::TwoPairs, Hands::ThreeOfAKind,
      Hands::Straight, Hands::Flush,
      Hands::FullHouse, Hands::FourOfAKind,
      Hands::StraightFlush].freeze

    # When you call max on an array of instances of a class, Ruby will use the <=> (spaceship)
    # operator to compare the objects. By default, the <=> operator returns nil unless the
    # class has a custom implementation for it.
    def <=>(other)
      rank_comparison =
        (RANKED_HANDS.index(level) <=> RANKED_HANDS.index(other.level))

      return rank_comparison unless rank_comparison.zero?

      # When hands are of the same type, use the level's detail_compare method
      level.new(hand) <=> level.new(other.hand)
    end

    # def >(other)
    #   level <=> other.level && top_five.map(&:value) > other.top_five.map(&:value)
    # end

    def ==(other)
      return false unless other.is_a?(Index)

      level == other.level && top_five.map(&:value) == other.top_five.map(&:value)
    end

    def level
      @level ||=
        RANKED_HANDS.reverse_each.find { |level| level.satisfied?(hand) }
    end

    def points
      level.top_five(hand).sum(&:value)
    end

    def top_five
      level.top_five(hand)
    end
  end
end
