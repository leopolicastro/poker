require "rails_helper"

RSpec.describe Chip, type: :model do
  describe "factories" do
    it "has a valid factory" do
      expect(build(:chip)).to be_valid
    end
  end
end

# == Schema Information
#
# Table name: chips
#
#  id             :integer          not null, primary key
#  chippable_type :string
#  value          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  chippable_id   :integer
#
# Indexes
#
#  index_chips_on_chippable  (chippable_type,chippable_id)
#
