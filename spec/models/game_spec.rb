require "rails_helper"

RSpec.describe Game, type: :model do
  describe "factories" do
    it "has a valid factory" do
      expect(build(:game)).to be_valid
    end
  end
end
