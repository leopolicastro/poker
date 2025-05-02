module Card::Images
  extend ActiveSupport::Concern

  included do
    def image
      "https://lbpdev.us-mia-1.linodeobjects.com/active_deck/cards/#{rank_key}#{suit_key}.png"
    end

    def self.random_image
      random_suit = Card.image_mapper[:suit][Card::SUITS.sample.to_sym]
      random_rank = Card.image_mapper[:rank][Card::RANKS.sample.to_sym]

      "https://lbpdev.us-mia-1.linodeobjects.com/active_deck/cards/#{random_rank}#{random_suit}.png"
    end

    def self.image_mapper
      {
        suit: {
          Hearts: "H",
          Spades: "S",
          Diamonds: "D",
          Clubs: "C"
        },
        rank: {
          Ace: "A",
          King: "K",
          Queen: "Q",
          Jack: "J",
          "10": "0",
          "9": "9",
          "8": "8",
          "7": "7",
          "6": "6",
          "5": "5",
          "4": "4",
          "3": "3",
          "2": "2"
        }
      }
    end

    private

    def suit_key(suit = self.suit)
      Card.image_mapper[:suit][suit.to_sym]
    end

    def rank_key(rank = self.rank)
      Card.image_mapper[:rank][rank.to_sym]
    end
  end
end
