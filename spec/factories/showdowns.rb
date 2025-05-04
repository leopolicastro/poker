FactoryBot.define do
  factory :showdown do
    association :game, factory: :game
  end
end
