require "rails_helper"

RSpec.describe Player, type: :model do
  describe "factories" do
    it "has a valid factory" do
      expect(build(:player)).to be_valid
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
#  table_position :string           default("field"), not null
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
