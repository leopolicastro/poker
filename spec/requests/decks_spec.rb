require "rails_helper"

RSpec.describe "Decks", type: :request do
  describe "GET /show" do
    let(:deck) { create(:deck) }

    it "returns http success" do
      get "/decks/#{deck.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
