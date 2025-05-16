require "rails_helper"

RSpec.describe CalculateOddsJob, type: :job do
  let(:game) { create(:game, :with_simulated_players, players_count: 3) }
  let(:round) { game.current_round }

  it "calls the calculate_odds method" do
    allow(round).to receive(:calculate_odds)
    CalculateOddsJob.perform_now(round)
    expect(round).to have_received(:calculate_odds)
  end
end
