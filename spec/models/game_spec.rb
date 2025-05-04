require "rails_helper"

RSpec.describe Game, type: :model do
  describe "factories" do
    it "has a valid factory" do
      expect(build(:game)).to be_valid
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
