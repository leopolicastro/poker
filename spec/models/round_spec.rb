require "rails_helper"

RSpec.describe Round, type: :model do
  it "has a valid factory" do
    expect(build(:round)).to be_valid
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id              :integer          not null, primary key
#  phase           :integer          default("pre_flop"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  current_turn_id :integer          not null
#  game_id         :integer          not null
#
# Indexes
#
#  index_rounds_on_current_turn_id  (current_turn_id)
#  index_rounds_on_game_id          (game_id)
#
# Foreign Keys
#
#  current_turn_id  (current_turn_id => players.id)
#  game_id          (game_id => games.id)
#
