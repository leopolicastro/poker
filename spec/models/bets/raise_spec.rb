require "rails_helper"

RSpec.describe Bets::Raise, type: :model do
  let(:game) { create(:game, :with_simulated_players, players_count: 2) }
  let(:hand) { game.current_hand }
  let(:round) { game.current_round }
  let(:player) { game.players.first }
  let(:other_player) { game.players.second }

  it "has a valid factory" do
    expect(build(:raise)).to be_valid
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  hand_id    :integer          not null
#
# Indexes
#
#  index_rounds_on_hand_id  (hand_id)
#
# Foreign Keys
#
#  hand_id  (hand_id => hands.id)
#
