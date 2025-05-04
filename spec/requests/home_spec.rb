require "rails_helper"

RSpec.describe "Homes", type: :request do
  describe "GET /show" do
    before do
      GameSimulatorService.run
    end

    it "returns http success" do
      get "/"
      expect(response.body).to include("Demo Game")
    end
  end
end
