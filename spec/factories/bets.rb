FactoryBot.define do
  factory :bet do
    association :player, factory: :player
    association :round, factory: :round
    amount { 1 }
    type { "Bets::Check" }

    after(:build) do |bet|
      create(:player_chip, chippable: bet.player, value: 100)
    end
  end

  factory :check, class: "Bets::Check" do
    association :player, factory: :player
    association :round, factory: :round
    amount { 0 }
    type { "Bets::Check" }

    after(:build) do |bet|
      create(:player_chip, chippable: bet.player, value: 100)
    end
  end

  factory :fold, class: "Bets::Fold" do
    association :player, factory: :player
    association :round, factory: :round
    amount { 0 }
    type { "Bets::Fold" }

    after(:build) do |bet|
      create(:player_chip, chippable: bet.player, value: 100)
    end
  end

  factory :blind, class: "Bets::Blind" do
    association :player, factory: :player
    association :round, factory: :round
    amount { 1 }
    type { "Bets::Blind" }

    after(:build) do |bet|
      create(:player_chip, chippable: bet.player, value: 100)
    end
  end

  factory :call, class: "Bets::Call" do
    association :player, factory: :player
    association :round, factory: :round
    amount { 1 }
    type { "Bets::Call" }

    after(:build) do |bet|
      create(:player_chip, chippable: bet.player, value: 100)
    end
  end

  factory :raise, class: "Bets::Raise" do
    association :player, factory: :player
    association :round, factory: :round
    amount { 1 }
    type { "Bets::Raise" }

    after(:build) do |bet|
      create(:player_chip, chippable: bet.player, value: 100)
    end
  end
end

# == Schema Information
#
# Table name: bets
#
#  id          :integer          not null, primary key
#  amount      :integer          default(0), not null
#  answered    :boolean          default(FALSE), not null
#  rotate_turn :boolean          default(TRUE), not null
#  state       :integer          default("placed"), not null
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  player_id   :integer          not null
#  round_id    :integer          not null
#
# Indexes
#
#  index_bets_on_player_id  (player_id)
#  index_bets_on_round_id   (round_id)
#
# Foreign Keys
#
#  player_id  (player_id => players.id)
#  round_id   (round_id => rounds.id)
#
