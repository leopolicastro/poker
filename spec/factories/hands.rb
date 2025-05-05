FactoryBot.define do
  factory :game_hand, class: "Hand" do
    association :game, factory: :game
  end
end

# == Schema Information
#
# Table name: hands
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer          not null
#
# Indexes
#
#  index_hands_on_game_id  (game_id)
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#
