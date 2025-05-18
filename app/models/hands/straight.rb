module Hands
  class Straight < Base
    class << self
      def satisfied?(hand)
        card_combinations = hand.combination(5)
        card_combinations.any? do |combination|
          ace_low_satisfied?(combination) || ace_high_satisfied?(combination)
        end
      end

      # called by satisfied? method
      def ace_low_satisfied?(hand)
        sorted_values = hand.ace_low_values
        sorted_values.each_cons(2).all? { |a, b| b == a + 1 }
      end

      # called by satisfied? method
      def ace_high_satisfied?(hand)
        sorted_values = hand.sorted_values
        sorted_values.each_cons(2).all? { |a, b| b == a + 1 }
      end

      def top_five(hand)
        ace_high_straights = []
        ace_low_straights = []

        hand.cards.combination(5).each do |combination|
          if consecutive?(combination, :value)
            ace_high_straights << combination
          end

          if consecutive?(combination, :ace_low_value)
            ace_low_straights << combination
          end
        end

        best_hand(ace_high_straights, :value) || best_hand(ace_low_straights, :ace_low_value)
      end

      # called by top_five method
      def consecutive?(combination, value_method)
        sorted_values = combination.sort_by(&value_method).map(&value_method)
        sorted_values.each_cons(2).all? { |a, b| b == a + 1 }
      end

      # called by top_five method
      def best_hand(straights, value_method)
        return if straights.empty?

        straights.max_by { |combination| combination.sum(&value_method) }
          .sort_by(&value_method)
      end
    end
  end
end
