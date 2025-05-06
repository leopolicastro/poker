module Hands
  class Hand
    attr_reader :cards, :player_id

    def initialize(cards:, player_id: nil)
      @cards = cards
      @player_id = player_id
    end

    def combination(x)
      cards.combination(x).map { |c| Hand.new(cards: c, player_id:) }
    end

    def suits
      cards.map(&:suit)
    end

    def sorted_values
      values = cards.map(&:value)
      values.sort!
      values
    end

    def sorted_for_ace_low_values
      values = cards.map(&:ace_low_value)
      values.sort!
      values
    end

    def cards_sorted_for_ace_low
      cards.sort_by(&:ace_low_value)
    end

    def cards_sorted_for_ace_high
      cards.sort_by(&:value)
    end

    # def hand_strength
    #   @hand_strength ||= HandStrength.new(self)
    # end

    def +(other)
      Hand.new(cards: cards + other.cards, player_id:)
    end

    # def values_desc_by_occurency
    #   values = cards.map(&:value)

    #   values.sort do |a, b|
    #     coefficient_occurency = (values.count(a) <=> values.count(b))

    #     coefficient_occurency.zero? ? -(a <=> b) : -coefficient_occurency
    #   end
    # end

    def values_desc_by_occurency
      values = cards.map(&:value)

      values.sort do |a, b|
        count_comparison = values.count(a) <=> values.count(b)

        if count_comparison.zero?
          b <=> a
        else
          -count_comparison
        end
      end
    end
  end
end
