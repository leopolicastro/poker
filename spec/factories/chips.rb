FactoryBot.define do
  factory :chip do
    value { 100 }
  end
  # chips for players
  factory :player_chip, parent: :chip do
    association :chippable, factory: :player
  end

  # chips for games
  factory :game_chip, parent: :chip do
    association :chippable, factory: :game
  end

  # chips for users
  factory :user_chip, parent: :chip do
    association :chippable, factory: :user
  end
end

# == Schema Information
#
# Table name: chips
#
#  id             :integer          not null, primary key
#  chippable_type :string
#  value          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  chippable_id   :integer
#
# Indexes
#
#  index_chips_on_chippable  (chippable_type,chippable_id)
#
