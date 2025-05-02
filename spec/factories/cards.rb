FactoryBot.define do
  factory :card do
    association :deck
    rank { "2" }
    suit { "Hearts" }
  end

  # factory :player_card, parent: :card do
  #   association :cardable, factory: :player
  # end

  # factory :game_card, parent: :card do
  #   association :cardable, factory: :game
  # end

  # factory :texas_holdem_card, parent: :card do
  #   association :cardable, factory: :texas_holdem
  # end
end

# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  cardable_type :string
#  position      :integer
#  rank          :string
#  suit          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  cardable_id   :integer
#  deck_id       :integer          not null
#
# Indexes
#
#  index_cards_on_cardable  (cardable_type,cardable_id)
#  index_cards_on_deck_id   (deck_id)
#
# Foreign Keys
#
#  deck_id  (deck_id => decks.id)
#
