FactoryBot.define do
  factory :pre_flop do
    association :game, factory: :game
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer          not null
#
# Indexes
#
#  index_rounds_on_game_id  (game_id)
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#
