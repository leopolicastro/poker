require "rails_helper"

RSpec.describe Game, type: :model do
  let(:game) { create(:game, :with_simulated_players, players_count: 3) }
  let(:all_in_player) { game.players.first }
  let(:other_players) { game.players.last(2) }

  describe "#all_in_payout!" do
    before do
      all_in_player.update!(state: :all_in)
    end

    it "handles all-in players correctly" do
      game.all_in_payout!(winners: [all_in_player])
      expect(all_in_player.current_holdings).to eq(1030)
    end

    it "handles multiple winners with all-in players" do
      game.all_in_payout!(winners: [all_in_player, other_players.first])
      expect(all_in_player.current_holdings).to eq(1000)
      expect(other_players.first.current_holdings).to eq(1010)
    end

    context "with different all-in amounts" do
      before do
        # Create a hand and round for the bets
        hand = create(:game_hand, game: game)
        round = create(:pre_flop, hand: hand)

        # Set up different bet amounts for each player
        create(:bet, player: all_in_player, round: round, amount: 100)
        create(:bet, player: other_players.first, round: round, amount: 200)
        create(:bet, player: other_players.last, round: round, amount: 300)
      end

      # pending it "creates multiple pots based on all-in amounts" do
      #   game.all_in_payout!(winners: [all_in_player, other_players.first, other_players.last])
      #   expect(all_in_player.current_holdings).to eq(300)  # Gets 100 from each pot
      #   expect(other_players.first.current_holdings).to eq(400)  # Gets 100 from first pot, 200 from second
      #   expect(other_players.last.current_holdings).to eq(500)  # Gets 100 from first pot, 200 from second, 300 from third
      # end
    end

    context "with different hand rankings" do
      before do
        # Create a hand and round for the bets
        hand = create(:game_hand, game: game)
        round = create(:pre_flop, hand: hand)

        # Set up different bet amounts for each player
        create(:bet, player: all_in_player, round: round, amount: 100)
        create(:bet, player: other_players.first, round: round, amount: 200)
        create(:bet, player: other_players.last, round: round, amount: 300)

        # Mock hand rankings
        allow(all_in_player).to receive(:hand).and_return(double(level: :high_card))
        allow(other_players.first).to receive(:hand).and_return(double(level: :pair))
        allow(other_players.last).to receive(:hand).and_return(double(level: :two_pair))
      end

      it "distributes pots based on hand rankings" do
        game.all_in_payout!(winners: [all_in_player, other_players.first, other_players.last])
        # Best hand (two_pair) should get the most chips
        expect(other_players.last.current_holdings).to be > other_players.first.current_holdings
        expect(other_players.first.current_holdings).to be > all_in_player.current_holdings
      end
    end

    # pending context "with same all-in amounts" do
    #   before do
    #     # Create a hand and round for the bets
    #     hand = create(:game_hand, game: game)
    #     round = create(:pre_flop, hand: hand)

    #     # Set up same bet amounts for each player
    #     create(:bet, player: all_in_player, round: round, amount: 100)
    #     create(:bet, player: other_players.first, round: round, amount: 100)
    #     create(:bet, player: other_players.last, round: round, amount: 100)
    #   end

    #   it "splits pot evenly between winners" do
    #     game.all_in_payout!(winners: [all_in_player, other_players.first, other_players.last])
    #     expect(all_in_player.current_holdings).to eq(other_players.first.current_holdings)
    #     expect(other_players.first.current_holdings).to eq(other_players.last.current_holdings)
    #   end
    # end

    context "with zero remaining players" do
      before do
        # Create a hand and round for the bets
        hand = create(:game_hand, game: game)
        round = create(:pre_flop, hand: hand)

        # Set up zero bet amounts for each player
        create(:bet, player: all_in_player, round: round, amount: 0)
        create(:bet, player: other_players.first, round: round, amount: 0)
        create(:bet, player: other_players.last, round: round, amount: 0)
      end

      it "handles zero all-in amounts gracefully" do
        expect {
          game.all_in_payout!(winners: [all_in_player, other_players.first, other_players.last])
        }.not_to raise_error
      end
    end
  end
end
