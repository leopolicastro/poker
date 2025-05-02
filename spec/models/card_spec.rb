require "rails_helper"

RSpec.describe Card, type: :model do
  describe "factories" do
    it "has a valid factory" do
      expect(build(:card)).to be_valid
    end

    # it "has a valid player_card factory" do
    #   expect(build(:player_card)).to be_valid
    # end

    # it "has a valid game_card factory" do
    #   expect(build(:game_card)).to be_valid
    # end

    # it "has a valid texas_holdem_card factory" do
    #   expect(build(:texas_holdem_card)).to be_valid
    # end
  end

  describe "associations" do
    it { is_expected.to belong_to(:deck) }
    it { is_expected.to belong_to(:cardable).optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:rank) }
    it { is_expected.to validate_presence_of(:suit) }
  end

  describe "instance methods" do
    let(:deck) { create(:deck) }
    let(:card) { deck.find_card("2", "Hearts") }

    describe "#to_s" do
      it "returns the rank and suit icon" do
        expect(card.to_s).to eq("2♥")
      end
    end

    describe "#suit_icon" do
      it "returns the suit icon" do
        expect(card.suit_icon).to eq("♥")
      end
    end

    describe "#value" do
      it "returns the value of the card" do
        expect(card.value).to eq(2)
      end
    end

    describe "#ace_low_value" do
      let(:card) { deck.find_card("Ace", "Hearts") }
      it "returns the ace low value of the card" do
        expect(card.ace_low_value).to eq(1)
      end
    end
  end

  describe "scopes" do
    describe ".drawn" do
      let(:deck) { create(:deck) }
      let(:card) { deck.find_card("2", "Hearts") }
      let(:player) { create(:player) }

      it "returns drawn cards" do
        card.update(cardable: player)
        expect(Card.drawn).to include(card)
      end
    end

    describe ".left" do
      let(:deck) { create(:deck) }
      let(:card) { deck.find_card("2", "Hearts") }

      it "returns cards left" do
        expect(Card.left).to include(card)
      end
    end
  end

  describe "constants" do
    it "has RANKS" do
      expect(Card::RANKS).to eq(%w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace])
    end

    it "has ACE_LOW_RANKS" do
      expect(Card::ACE_LOW_RANKS).to eq(%w[Ace 2 3 4 5 6 7 8 9 10 Jack Queen King])
    end

    it "has SUITS" do
      expect(Card::SUITS).to eq(%w[Spades Hearts Diamonds Clubs])
    end
  end

  describe "concerns" do
    it "includes Images" do
      expect(Card.included_modules).to include(Card::Images)
    end

    describe "Images" do
      let(:deck) { create(:deck) }
      let(:card) { deck.find_card("2", "Hearts") }

      describe "#image" do
        it "returns the card image" do
          expect(card.image).to eq("https://lbpdev.us-mia-1.linodeobjects.com/active_deck/cards/2H.png")
        end
      end

      describe ".random_image" do
        it "returns a random card image" do
          expect(Card.random_image).to match(/https:\/\/lbpdev.us-mia-1.linodeobjects.com\/active_deck\/cards\/[A-Z0-9]{2}\.png/)
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  cardable_type :string
#  position      :integer
#  rank          :string
#  suit          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  cardable_id   :integer
#  deck_id       :integer          not null
#
# Indexes
#
#  index_cards_on_cardable  (cardable_type,cardable_id)
#  index_cards_on_deck_id   (deck_id)
#
# Foreign Keys
#
#  deck_id  (deck_id => decks.id)
#
