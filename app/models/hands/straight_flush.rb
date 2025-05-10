module Hands
  class StraightFlush < Base
    class << self
      def satisfied?(hand)
        if first_check?(hand)
          Flush.top_five(hand).combination(5).any? do |combination|
            h = Hand.new(cards: combination)
            Straight.satisfied?(h)
          end
        end
      end

      def first_check?(hand)
        Flush.satisfied?(hand) && Straight.satisfied?(hand)
      end

      def top_five(hand)
        # Determine the most frequent suit in the hand
        most_frequent_suit = hand.suits.max_by { |suit| hand.suits.count(suit) }

        # Select cards with the most frequent suit
        suited_cards = hand.cards.select { |card| card.suit == most_frequent_suit }

        ace_high_straights = []
        ace_low_straights = []

        suited_cards.combination(5).each do |combination|
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

    def detail_compare(other)
      # Get the top five cards for both hands
      my_cards = self.class.top_five(hand)
      other_cards = self.class.top_five(other.hand)

      # Check if either hand is an Ace-high straight flush
      my_is_ace_high = my_cards.last.value == 14 && my_cards.first.value == 10
      other_is_ace_high = other_cards.last.value == 14 && other_cards.first.value == 10

      # If one is Ace-high and the other isn't, Ace-high wins
      return 1 if my_is_ace_high && !other_is_ace_high
      return -1 if !my_is_ace_high && other_is_ace_high

      # If both are Ace-high or both are Ace-low, compare highest cards
      my_cards.last.value <=> other_cards.last.value
    end
  end
end
