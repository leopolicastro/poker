require "rails_helper"

RSpec.describe Hand, type: :model do
  let(:game) { create(:game) }

  it "has a valid factory" do
    expect(build(:game_hand, game:)).to be_valid
  end

  describe "associations" do
    it { is_expected.to belong_to(:game) }
    it { is_expected.to have_many(:rounds).dependent(:destroy) }
    it { is_expected.to have_many(:bets).through(:rounds) }
  end

  describe "#create_pre_flop!" do
    before do
      generate_players
      @hand = create(:game_hand, game:)
    end
    it "creates a pre-flop round" do
      expect(@hand.rounds.count).to eq(1)
      @hand.create_pre_flop!
      expect(@hand.rounds.count).to eq(2)
      expect(@hand.rounds.first).to be_a(Rounds::PreFlop)
    end

    it "activates all players" do
      game.players.each do |player|
        player.folded!
      end
      expect(game.players.active.count).to eq(0)
      @hand.create_pre_flop!
      expect(game.players.active.count).to eq(2)
    end
  end

  def generate_players
    (1..2).each do |i|
      user = User.find_or_create_by!(email_address: "demo-player#{i}@example.com") do |user|
        user.password = "password"
      end
      player = game.players.find_or_create_by!(user:)
      player.active!
      user.chips.create! value: 10000
      player.buy_in(1000)
    end
  end
end

# == Schema Information
#
# Table name: hands
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer          not null
#
# Indexes
#
#  index_hands_on_game_id  (game_id)
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#
