FactoryBot.define do
  factory :river do
    association :game, factory: :game
  end
end
