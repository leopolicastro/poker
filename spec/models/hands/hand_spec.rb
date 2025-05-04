require "rails_helper"

RSpec.describe Hands::Hand, type: :model do
  describe "factories" do
    it "has a valid base factory" do
      hand = build(:hand)
      expect(hand).to be_a(Hands::Hand)
    end

    it "has a valid high_card factory" do
      hand = build(:high_card)
      expect(hand).to be_a(Hands::Hand)
    end

    it "has a valid one_pair factory" do
      hand = build(:one_pair)
      expect(hand).to be_a(Hands::Hand)
    end

    it "has a valid two_pairs factory" do
      hand = build(:two_pairs)
      expect(hand).to be_a(Hands::Hand)
    end

    it "has a valid three_of_a_kind factory" do
      hand = build(:three_of_a_kind)
      expect(hand).to be_a(Hands::Hand)
    end

    it "has a valid straight factory" do
      hand = build(:straight)
      expect(hand).to be_a(Hands::Hand)
    end

    it "has a valid flush factory" do
      hand = build(:flush)
      expect(hand).to be_a(Hands::Hand)
    end

    it "has a valid full_house factory" do
      hand = build(:full_house)
      expect(hand).to be_a(Hands::Hand)
    end

    it "has a valid four_of_a_kind factory" do
      hand = build(:four_of_a_kind)
      expect(hand).to be_a(Hands::Hand)
    end

    it "has a valid straight_flush factory" do
      hand = build(:straight_flush)
      expect(hand).to be_a(Hands::Hand)
    end
  end
end
