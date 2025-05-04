module Hands
  class HighCard < Base
    def self.satisfied?(hand)
      true
    end

    def self.top_five(hand)
      five = hand.cards.sort_by(&:value).last(5)
      five.reverse!
      five
    end
  end
end
