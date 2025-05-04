module Hands
  class Flush
    def self.satisfied?(hand)
      suits = hand.suits
      suits.any? { |suit| suits.count(suit) >= 5 }
    end

    def self.top_five(hand)
      # Determine the most frequent suit in the hand
      most_frequent_suit = hand.suits.max_by { |suit| hand.suits.count(suit) }

      # Select cards with the most frequent suit
      suited_cards = hand.cards.select { |card| card.suit == most_frequent_suit }

      # Sort the selected cards by value and take the top 5
      top_five_cards = suited_cards.sort_by(&:value).last(5)

      # Return the top 5 cards in reverse order
      top_five_cards.reverse
    end
  end
end
