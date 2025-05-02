module Chippable
  extend ActiveSupport::Concern
  include ActionView::Helpers::NumberHelper

  included do
    has_many :chips, as: :chippable, dependent: :destroy

    accepts_nested_attributes_for :chips, allow_destroy: true

    def current_holdings
      chips.sum(:value)
    end
    alias_method :pot, :current_holdings

    def consolidate_chips
      current_amount = current_holdings
      chips.destroy_all
      chips.create!(value: current_amount)
    end

    def split_chips(amount:, chippable:)
      chips.first.update!(value: current_holdings - amount)
      Chip.create!(value: amount, chippable:)
    end
  end
end
