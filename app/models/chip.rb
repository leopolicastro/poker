class Chip < ApplicationRecord
  belongs_to :chippable, polymorphic: true, optional: true
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
