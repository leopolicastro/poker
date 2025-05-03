require "rails_helper"

RSpec.describe "Homes", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/"
      expect(response.body).to include("No deck found")
    end

    it "returns a deck" do
      create(:deck)
      get "/"
      expect(response.body).to include("Cards left: 52")
    end
  end
end
