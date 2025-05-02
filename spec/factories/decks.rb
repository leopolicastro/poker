FactoryBot.define do
  factory :deck do
    # association :deckable, factory: :player
    state { "initial" }
  end
end

# == Schema Information
#
# Table name: decks
#
#  id            :integer          not null, primary key
#  deckable_type :string
#  state         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deckable_id   :integer
#
# Indexes
#
#  index_decks_on_deckable  (deckable_type,deckable_id)
#
