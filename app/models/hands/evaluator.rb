module Hands
  module Evaluator
    module_function

    def find_winners(hands, board)
      top_hand_per_player_id = find_top_hands(hands, board)
      best_hand = top_hand_per_player_id.values.max
      top_hand_per_player_id
        .filter_map { |player_id, hand| player_id if hand == best_hand }
    end

    def find_top_hands(hands, board)
      result = {}
      indexes = hands.map do |hand|
        find_best_hand(board, hand)
      end.compact
      indexes.each do |index|
        player_id = index.hand.player_id

        result[player_id] = index
      end
      result
    end

    def find_best_hand(board, hand)
      all_cards = board + hand.cards
      best_combination_index(all_cards, hand)
    end

    def best_combination_index(cards, hand)
      combinations = cards.combination(cards.size).map { |passed_cards|
        Index.new(
          Hand.new(
            cards: passed_cards,
            player_id: hand.player_id
          )
        )
      }

      # When you call max on an array of instances of a class, Ruby will use the <=> (spaceship)
      # operator to compare the objects. By default, the <=> operator returns nil unless the
      # class has a custom implementation for it.
      combinations.max
    end
  end
end
