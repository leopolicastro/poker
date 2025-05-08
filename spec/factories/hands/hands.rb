FactoryBot.define do
  factory :hand, class: "Hands::Hand" do
    transient do
      deck { create(:deck) }
    end

    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "3", suit: "Club"),
        deck.cards.find_by(rank: "4", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Diamond"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ]
    end

    player_id { 1 }

    initialize_with { new(cards: cards, player_id: player_id) }
  end

  factory :high_card, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "3", suit: "Club"),
        deck.cards.find_by(rank: "4", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Diamond"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "A", suit: "Diamond")
      ]
    end
  end

  factory :one_pair, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "2", suit: "Club"),
        deck.cards.find_by(rank: "4", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Diamond"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ]
    end
  end

  factory :two_pairs, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "2", suit: "Club"),
        deck.cards.find_by(rank: "4", suit: "Spade"),
        deck.cards.find_by(rank: "4", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Diamond"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ]
    end
  end

  factory :three_of_a_kind, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "2", suit: "Club"),
        deck.cards.find_by(rank: "2", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Diamond"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ]
    end
  end

  factory :straight, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "10", suit: "Heart"),
        deck.cards.find_by(rank: "J", suit: "Club"),
        deck.cards.find_by(rank: "4", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Diamond"),
        deck.cards.find_by(rank: "6", suit: "Diamond"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ]
    end
  end

  factory :flush, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "3", suit: "Heart"),
        deck.cards.find_by(rank: "4", suit: "Heart"),
        deck.cards.find_by(rank: "5", suit: "Heart"),
        deck.cards.find_by(rank: "9", suit: "Heart"),
        deck.cards.find_by(rank: "8", suit: "Heart"),
        deck.cards.find_by(rank: "7", suit: "Heart")
      ]
    end
  end

  factory :full_house, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "2", suit: "Club"),
        deck.cards.find_by(rank: "2", suit: "Spade"),
        deck.cards.find_by(rank: "5", suit: "Diamond"),
        deck.cards.find_by(rank: "5", suit: "Heart"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ]
    end
  end

  factory :four_of_a_kind, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Heart"),
        deck.cards.find_by(rank: "2", suit: "Club"),
        deck.cards.find_by(rank: "2", suit: "Spade"),
        deck.cards.find_by(rank: "2", suit: "Diamond"),
        deck.cards.find_by(rank: "9", suit: "Diamond"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ]
    end
  end

  factory :straight_flush, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "10", suit: "Heart"),
        deck.cards.find_by(rank: "J", suit: "Heart"),
        deck.cards.find_by(rank: "Q", suit: "Heart"),
        deck.cards.find_by(rank: "K", suit: "Heart"),
        deck.cards.find_by(rank: "A", suit: "Heart"),
        deck.cards.find_by(rank: "8", suit: "Diamond"),
        deck.cards.find_by(rank: "7", suit: "Diamond")
      ]
    end
  end
end
