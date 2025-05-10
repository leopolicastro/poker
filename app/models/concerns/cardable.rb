module Cardable
  extend ActiveSupport::Concern

  included do
    has_many :cards, -> { where(burn_card: false) }, as: :cardable
    has_many :burn_cards, -> { where(burn_card: true) }, as: :cardable, class_name: "Card"
  end
end
