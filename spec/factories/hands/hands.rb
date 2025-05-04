FactoryBot.define do
  factory :hand, class: "Hands::Hand" do
    transient do
      deck { create(:deck) }
    end

    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Hearts"),
        deck.cards.find_by(rank: "3", suit: "Clubs"),
        deck.cards.find_by(rank: "4", suit: "Spades"),
        deck.cards.find_by(rank: "5", suit: "Diamonds"),
        deck.cards.find_by(rank: "9", suit: "Diamonds"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "7", suit: "Diamonds")
      ]
    end

    player_id { 1 }

    initialize_with { new(cards: cards, player_id: player_id) }
  end

  factory :high_card, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Hearts"),
        deck.cards.find_by(rank: "3", suit: "Clubs"),
        deck.cards.find_by(rank: "4", suit: "Spades"),
        deck.cards.find_by(rank: "5", suit: "Diamonds"),
        deck.cards.find_by(rank: "9", suit: "Diamonds"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "Ace", suit: "Diamonds")
      ]
    end
  end

  factory :one_pair, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Hearts"),
        deck.cards.find_by(rank: "2", suit: "Clubs"),
        deck.cards.find_by(rank: "4", suit: "Spades"),
        deck.cards.find_by(rank: "5", suit: "Diamonds"),
        deck.cards.find_by(rank: "9", suit: "Diamonds"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "7", suit: "Diamonds")
      ]
    end
  end

  factory :two_pairs, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Hearts"),
        deck.cards.find_by(rank: "2", suit: "Clubs"),
        deck.cards.find_by(rank: "4", suit: "Spades"),
        deck.cards.find_by(rank: "4", suit: "Diamonds"),
        deck.cards.find_by(rank: "9", suit: "Diamonds"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "7", suit: "Diamonds")
      ]
    end
  end

  factory :three_of_a_kind, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Hearts"),
        deck.cards.find_by(rank: "2", suit: "Clubs"),
        deck.cards.find_by(rank: "2", suit: "Spades"),
        deck.cards.find_by(rank: "5", suit: "Diamonds"),
        deck.cards.find_by(rank: "9", suit: "Diamonds"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "7", suit: "Diamonds")
      ]
    end
  end

  factory :straight, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "10", suit: "Hearts"),
        deck.cards.find_by(rank: "Jack", suit: "Clubs"),
        deck.cards.find_by(rank: "4", suit: "Spades"),
        deck.cards.find_by(rank: "5", suit: "Diamonds"),
        deck.cards.find_by(rank: "6", suit: "Diamonds"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "7", suit: "Diamonds")
      ]
    end
  end

  factory :flush, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Hearts"),
        deck.cards.find_by(rank: "3", suit: "Hearts"),
        deck.cards.find_by(rank: "4", suit: "Hearts"),
        deck.cards.find_by(rank: "5", suit: "Hearts"),
        deck.cards.find_by(rank: "9", suit: "Hearts"),
        deck.cards.find_by(rank: "8", suit: "Hearts"),
        deck.cards.find_by(rank: "7", suit: "Hearts")
      ]
    end
  end

  factory :full_house, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Hearts"),
        deck.cards.find_by(rank: "2", suit: "Clubs"),
        deck.cards.find_by(rank: "2", suit: "Spades"),
        deck.cards.find_by(rank: "5", suit: "Diamonds"),
        deck.cards.find_by(rank: "5", suit: "Hearts"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "7", suit: "Diamonds")
      ]
    end
  end

  factory :four_of_a_kind, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "2", suit: "Hearts"),
        deck.cards.find_by(rank: "2", suit: "Clubs"),
        deck.cards.find_by(rank: "2", suit: "Spades"),
        deck.cards.find_by(rank: "2", suit: "Diamonds"),
        deck.cards.find_by(rank: "9", suit: "Diamonds"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "7", suit: "Diamonds")
      ]
    end
  end

  factory :straight_flush, parent: :hand do
    cards do
      [
        deck.cards.find_by(rank: "10", suit: "Hearts"),
        deck.cards.find_by(rank: "Jack", suit: "Hearts"),
        deck.cards.find_by(rank: "Queen", suit: "Hearts"),
        deck.cards.find_by(rank: "King", suit: "Hearts"),
        deck.cards.find_by(rank: "Ace", suit: "Hearts"),
        deck.cards.find_by(rank: "8", suit: "Diamonds"),
        deck.cards.find_by(rank: "7", suit: "Diamonds")
      ]
    end
  end
end
