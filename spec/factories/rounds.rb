FactoryBot.define do
  factory :round do
    association :hand, factory: :game_hand
    type { "Rounds::PreFlop" }
  end
end

# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  odds       :json             not null
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  hand_id    :integer          not null
#
# Indexes
#
#  index_rounds_on_hand_id  (hand_id)
#
# Foreign Keys
#
#  hand_id  (hand_id => hands.id)
#
