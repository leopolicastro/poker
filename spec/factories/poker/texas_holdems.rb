FactoryBot.define do
  factory :texas_holdem, parent: :game, class: "Poker::TexasHoldem" do
    state { "setup" }
  end
end

# == Schema Information
#
# Table name: games
#
#  id            :bigint           not null, primary key
#  max_players   :integer          default(10), not null
#  min_players   :integer          default(2), not null
#  name          :string
#  players_count :integer          default(0), not null
#  rounds_count  :integer          default(0)
#  state         :string           default("setup"), not null
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
