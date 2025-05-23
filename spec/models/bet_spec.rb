require "rails_helper"

RSpec.describe Bet, type: :model do
  it "has a valid factory" do
    expect(build(:bet)).to be_valid
  end
end

# == Schema Information
#
# Table name: bets
#
#  id          :integer          not null, primary key
#  amount      :integer          default(0), not null
#  answered    :boolean          default(FALSE), not null
#  rotate_turn :boolean          default(TRUE), not null
#  state       :integer          default("placed"), not null
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  player_id   :integer          not null
#  round_id    :integer          not null
#
# Indexes
#
#  index_bets_on_player_id  (player_id)
#  index_bets_on_round_id   (round_id)
#
# Foreign Keys
#
#  player_id  (player_id => players.id)
#  round_id   (round_id => rounds.id)
#
