FactoryBot.define do
  factory :game do
    name { "Demo Game" }
    small_blind { 10 }
    big_blind { 20 }

    trait :with_simulated_players do
      transient do
        players_count { 5 }
      end

      after(:create) do |game, evaluator|
        evaluator.players_count.times do |i|
          user = create(:user, email_address: "demo-player#{i + 1}@example.com")
          create(:user_chip, chippable: user, value: 10000)
          player = create(:player, game: game, user: user)
          player.buy_in(1000)
        end
        create(:game_hand, game: game)
      end
    end
  end
end

# == Schema Information
#
# Table name: games
#
#  id          :integer          not null, primary key
#  big_blind   :integer
#  name        :string           not null
#  small_blind :integer
#  state       :integer          default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
