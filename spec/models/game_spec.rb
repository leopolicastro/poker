require "rails_helper"

RSpec.describe Game, type: :model do
  describe "factories" do
    it "has a valid factory" do
      expect(build(:game)).to be_valid
    end

    it "has a valid factory with simulated players" do
      expect(build(:game, :with_simulated_players, players_count: 2)).to be_valid
    end
  end

  describe "associations" do
    it { should have_one(:deck).dependent(:destroy) }
    it { should have_many(:players).dependent(:destroy) }
    it { should have_many(:hands).dependent(:destroy) }
    it { should have_many(:rounds).through(:hands) }
    it { should have_many(:bets).through(:hands) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "enums" do
    it { should define_enum_for(:state).with_values(pending: 0, in_progress: 1, finished: 2) }
  end

  describe "callbacks" do
    it "creates a deck after creation" do
      game = create(:game)
      expect(game.deck).to be_present
    end
  end

  describe "#split_pot_payout!" do
    let(:game) { create(:game, :with_simulated_players, players_count: 3) }
    let(:winners) { game.players.first(2) }

    before do
      # Create some chips in the pot
      winners.each do |winner|
        game.current_round.bets.create!(player: winner, amount: winner.owes_the_pot, type: "Bets::Call")
        # winner.chips.create!(value: 1000)
      end
    end

    it "splits the pot evenly among winners" do
      game.split_pot_payout!(winners: winners)

      winners.each do |winner|
        expect(winner.current_holdings).to eq(1040) # (1000 / 2 winners) + starting 1000
      end
    end

    it "updates bet states to won for winners" do
      game.split_pot_payout!(winners: winners)

      winners.each do |winner|
        expect(game.current_hand.bets.placed.where(player: winner).all? { |bet| bet.won? }).to be true
      end
    end

    it "leaves games with 0 in chips" do
      game.split_pot_payout!(winners: winners)
      expect(game.chips.sum(:value)).to eq(0)
    end
  end

  describe "#draw" do
    let(:game) { create(:game) }

    it "draws cards from the deck" do
      expect { game.draw(count: 2) }.to change { game.cards.count }.by(2)
    end

    it "can draw burn cards" do
      expect { game.draw(count: 1, burn_card: true) }.to change { game.burn_cards.count }.by(1)
    end
  end

  describe "#top_hands" do
    let(:game) { create(:game, :with_simulated_players, players_count: 3) }

    it "returns players with the best hands" do
      # Set up some cards for players
      game.players.each do |player|
        player.cards.find_by(rank: "A", suit: "Spade", deck: game.deck)
        player.cards.find_by(rank: "K", suit: "Spade", deck: game.deck)
      end

      expect(game.top_hands).to be_an(Array)
      expect(game.top_hands).to all(be_a(Player))
    end
  end

  describe "#assign_starting_positions!" do
    let(:game) { create(:game, :with_simulated_players, players_count: 4) }

    it "assigns correct positions to players" do
      game.assign_starting_positions!

      expect(game.players.button.count).to eq(1)
      expect(game.players.small_blind.count).to eq(1)
      expect(game.players.big_blind.count).to eq(1)
      expect(game.players.field.count).to eq(1)
    end
  end

  describe "#in_progress!" do
    let(:game) { create(:game, :with_simulated_players) }

    it "changes game state to in_progress" do
      game.in_progress!
      expect(game.in_progress?).to be true
    end
  end

  describe "#add_player" do
    let(:game) { create(:game) }
    let(:user) { create(:user) }

    it "creates a new player for the user" do
      expect { game.add_player(user: user) }.to change { game.players.count }.by(1)
      expect(game.players.last.user).to eq(user)
    end
  end

  describe "#current_turn" do
    let(:game) { create(:game, :with_simulated_players) }

    it "returns the player whose turn it is" do
      player = game.players.first
      player.update!(turn: true)
      expect(game.current_turn).to eq(player)
    end
  end

  describe "#chip_leader" do
    let(:game) { create(:game, :with_simulated_players) }

    it "returns the player with the most chips" do
      leader = game.players.first
      leader.chips.create!(value: 1000)
      expect(game.chip_leader).to eq(leader)
    end
  end

  describe "#next_player" do
    let(:game) { create(:game, :with_simulated_players) }

    it "returns the next active player in order" do
      current = game.players.first
      current.update!(turn: true)
      next_player = game.next_player
      expect(next_player).to eq(game.players.second)
    end
  end

  describe "#current_round" do
    let(:game) { create(:game, :with_simulated_players) }

    it "returns the last round of the current hand" do
      round = create(:pre_flop, hand: game.current_hand)
      expect(game.current_round).to eq(round)
    end
  end

  describe "#current_hand" do
    let(:game) { create(:game, :with_simulated_players) }

    it "returns the last hand" do
      hand = create(:game_hand, game: game)
      expect(game.current_hand).to eq(hand)
    end
  end

  describe "#pot" do
    let(:game) { create(:game, :with_simulated_players) }

    it "returns the sum of all placed bets in the current hand" do
      player = game.players.first
      create(:bet, player: player, round: game.current_round, amount: 100)
      # 130, 100 for bet, 30 for blinds
      expect(game.pot).to eq(130)
    end
  end

  describe "player count methods" do
    let(:game) { create(:game, :with_simulated_players, players_count: @players_count) }

    it "#heads_up? returns true for 2 players" do
      @players_count = 2
      expect(game.heads_up?).to be true
    end

    it "#three_player? returns true for 3 players" do
      @players_count = 3
      expect(game.three_player?).to be true
    end
  end

  describe "#on_the_button" do
    let(:game) { create(:game, :with_simulated_players) }

    it "returns the player on the button" do
      button_player = game.players.first
      button_player.update!(table_position: :button)
      expect(game.on_the_button).to eq(button_player)
    end
  end

  describe "#first_hand?" do
    let(:game) { create(:game, :with_simulated_players) }

    it "returns true when there is only one hand" do
      expect(game.first_hand?).to be true
    end

    it "returns false when there are multiple hands" do
      create(:game_hand, game: game)
      expect(game.first_hand?).to be false
    end
  end
end

# == Schema Information
#
# Table name: games
#
#  id          :integer          not null, primary key
#  big_blind   :integer
#  name        :string           not null
#  small_blind :integer
#  state       :integer          default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
