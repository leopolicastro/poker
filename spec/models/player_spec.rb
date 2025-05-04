require "rails_helper"

RSpec.describe Player, type: :model do
  let(:game) { create(:game) }

  let!(:player1) { create(:player, game: game) }
  let!(:player2) { create(:player, game: game) }
  let!(:player3) { create(:player, game: game) }
  let(:deck) { create(:deck, deckable: game) }

  describe "factory" do
    it "has a valid factory" do
      expect(build(:player)).to be_valid
    end
  end

  describe "#position" do
    # let(:game) { create(:game) }

    before do
      player1
      player2
      player3
    end

    it "auto increments the position" do
      expect(player1.position).to eq(1)
      expect(player2.position).to eq(2)
      expect(player3.position).to eq(3)
    end

    it "manages positions per game" do
      game2 = create(:game)
      player4 = create(:player, game: game2)
      player5 = create(:player, game: game2)
      expect(player4.position).to eq(1)
      expect(player5.position).to eq(2)
    end

    it "updates the position when a player is destroyed" do
      player2.destroy
      player3.reload
      expect(player3.position).to eq(2)
    end

    it "updates the position when a player is inserted in the middle" do
      player2.destroy
      player4 = create(:player, game: game)
      player3.reload
      expect(player3.position).to eq(2)
      expect(player4.position).to eq(3)
    end

    describe "higher_item" do
      it "returns the next higher item" do
        expect(player1.higher_item).to eq(nil)
        expect(player2.higher_item).to eq(player1)
        expect(player3.higher_item).to eq(player2)
      end
    end

    describe "lower_item" do
      it "returns the next lower item" do
        expect(player1.lower_item).to eq(player2)
        expect(player2.lower_item).to eq(player3)
        expect(player3.lower_item).to eq(nil)
      end
    end

    describe "gets the first item" do
    end
  end

  describe "#cards_left" do
    let(:player) { create(:player, game:) }
    let(:player_cards) {
      [
        deck.find_card("2", "Hearts"),
        deck.find_card("3", "Hearts")
      ]
    }

    before do
      player_cards.each do |card|
        card.update(cardable: player)
      end
    end

    it "returns the number of cards left" do
      expect(player.cards_left).to eq(2)
    end
  end

  describe "#place_bet!" do
    let(:player) { create(:player, game: game) }

    before do
      create(:player_chip, chippable: player, value: 100)
      create(:player_chip, chippable: player, value: 200)
      create(:player_chip, chippable: player, value: 150)
      create(:pre_flop, game:)
    end

    it "places a bet" do
      bet = player.place_bet!(amount: 100, bet_type: :raise)
      expect(bet).to be_valid
      expect(player.current_holdings).to eq(350)
      expect(player.bets.count).to eq(1)
      expect(game.chips.count).to eq(1)
    end

    it "does not place a bet if the player does not have enough chips" do
      expect(player.current_holdings).to eq(450)
      bet = player.place_bet!(amount: 500, bet_type: :raise)
      expect(bet).to be_nil
      expect(game.chips.count).to eq(0)
    end
  end

  describe "#end_turn!" do
    let(:player) { create(:player, game:, turn: true) }
    it "ends the turn" do
      player.send(:end_turn!)
      expect(player.turn).to be_falsey
    end
  end
end

# == Schema Information
#
# Table name: players
#
#  id             :integer          not null, primary key
#  dealer         :boolean          default(FALSE), not null
#  position       :integer          default(0), not null
#  state          :integer          default("active"), not null
#  table_position :integer          default("field"), not null
#  turn           :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  game_id        :integer          not null
#  user_id        :integer          not null
#
# Indexes
#
#  index_players_on_game_id  (game_id)
#  index_players_on_user_id  (user_id)
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#  user_id  (user_id => users.id)
#
