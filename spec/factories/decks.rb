FactoryBot.define do
  factory :deck do
  end
end

# == Schema Information
#
# Table name: decks
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer
#
# Indexes
#
#  index_decks_on_game_id  (game_id)
#
# Foreign Keys
#
#  game_id  (game_id => games.id)
#
