module Cardable
  extend ActiveSupport::Concern

  included do
    has_many :cards, -> { where(burn_card: false) }, as: :cardable
  end
end
