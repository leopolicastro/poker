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
