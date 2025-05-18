FactoryBot.define do
  factory :bot_setting do
    association :user
    strategy { 0 }
    instructions { "MyText" }
  end
end

# == Schema Information
#
# Table name: bot_settings
#
#  id           :integer          not null, primary key
#  active       :boolean          default(FALSE), not null
#  instructions :text
#  strategy     :integer          default("conservative"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_bot_settings_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
