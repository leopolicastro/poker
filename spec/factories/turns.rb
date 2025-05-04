FactoryBot.define do
  factory :turn do
    association :game, factory: :game
  end
end
