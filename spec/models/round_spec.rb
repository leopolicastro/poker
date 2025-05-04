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
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer          not null
#
# Indexes
#
#  index_rounds_on_game_id  (game_id)
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#
